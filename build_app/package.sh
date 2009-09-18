#!/bin/sh
exec scala -deprecation "$0" "$@"
!#

def check( assertion:Boolean, msg:String )={
  if( !assertion ){
    println( msg )
    exit(1)
  }
}


check( args.length==1, """package.sh <export directory>""")

// Supporting classes and methods

import java.io._
import scala.collection.mutable._
import java.util.zip._

trait IteratorSeq[+A] extends Seq[A] {  
  def apply(i : Int) : A = elements.drop(i).next  
  def length = elements.foldLeft(0){ (n,e) => n + 1 }
  
  // Default implementation would be O(n)  
  override def isEmpty = !elements.hasNext
} 
/** Keeps running the block until it returns a negative number. */  
def nonNegative(f : => Int) =  {
  new Iterator[Int] {  
    private var n = 0  
    private var h = false  
    
    def hasNext = {  
      if(!h) {  
        n = f  
        h = true  
      }  
      n >= 0  
    }  
    
    def next = {  
      if(!h) n = f  
      h = false  
      n  
    }  
  }  
}

def nonNull[A](f : => A) =  {
  new Iterator[A] {  
    private var n : A = _  
    private var h = false  
    
    def hasNext = {  
      if(!h) {  
        n = f  
        h = true  
      }  
      n != null  
    }  
    
    def next = {  
      if(!h) n = f  
      h = false  
      n  
    }  
  }
}


class FileTree(val root : File) extends IteratorSeq[File] {
  def elements = new Walk
  class Walk private[FileTree] extends Iterator[File] {
    private val files = new Queue[File]();
    private val dirs = new Queue[File]();
    private var failed = false;
    dirs.enqueue(root)
    
    private def enqueue(dir: File) = {
      val list = dir.listFiles()
      if(list == null) {
        failed = true;
      } else {
        for (file <- dir.listFiles()) {
          if (file.isDirectory()) dirs.enqueue(file)
          else files.enqueue(file)
        }
      }
      dir
    }
    
    def hasNext = files.length != 0 || dirs.length != 0
    
    def next() = {
      failed = false;
      if (!hasNext) throw new NoSuchElementException("No more results")
      if (files.length != 0) files.dequeue else enqueue(dirs.dequeue)
    }
    
    def wasUnreadable = failed;
  }
}

implicit def fileToRichFile( f:File ) = new RichFile(f)

class RichFile( f:File ) {

  val tree = new FileTree(f)

  def pumpTo(stream:OutputStream) = {
    val buf = new Array[Byte](65536)
    val in = new BufferedInputStream(new FileInputStream(f), buf.size)
    val out = new BufferedOutputStream(stream, buf.size)
    
    var r = in.read(buf)

    while( r>0){
      out.write(buf,0,r)
      r = in.read(buf)
    }
  }

  def deleteRecurse() = {
    def doDelete(file:File):Boolean = {
      if(file.isDirectory && file.listFiles != null ) file.listFiles.foreach( doDelete _ )

      file.delete()
    }

    doDelete(f)
  }

  def unzip(outdir : File) : Unit = {
    val zip = new FileInputStream(f)
    val zis = new ZipInputStream(new BufferedInputStream(zip))
    val buf = new Array[Byte](65536)
    for(entry <- nonNull { zis.getNextEntry() }) {
      val f = new File(outdir, entry.getName())
      if(entry.isDirectory()) {
        if(!f.mkdir())
          throw new IOException("Couldn't create directory")
      }
        else {
          val fos = new FileOutputStream(f)
          val dest = new BufferedOutputStream(fos, 65536)
          for(cnt <- nonNegative{ zis.read(buf) }) {
            dest.write(buf, 0, cnt)
          }
          dest.flush()
          dest.close()
        }
    }
    zis.close()
  }
  


  def zip(src:File,dest:File, root:File){
    val zip=new ZipOutputStream(new java.io.FileOutputStream(dest))
    try{
      for( f <- src.tree; if f.isFile ){
        val entry = new ZipEntry( relative(root,f) )
        
        zip.putNextEntry(entry)
        if( f.isFile ) {
          f.pumpTo(zip)
        }
        zip.closeEntry()
      }
    }finally{
      zip.close()
    }
  }

  def relative( root:File, file:File ):String = {
    file.getPath.drop(root.getPath.length+1)
  }
}

//   MAIN SCRIPT LOGIC

val pluginsToUnzip = List(
  """org\.talend\.libraries.*""".r,
  """org\.talend\.repositor.*""".r
)

// I have found that certain plugins can cause problems
// so I have added these plugin(s) to delete
val pluginsToDelete = List("""org.apache.log4j\.*""")

def process( pluginsDir: File){
// Delete plugins that are found to cause problems
  println("Deleting plugins found to cause problems")
  for( file <- pluginsDir.listFiles; name=file.getName; if( pluginsToDelete.exists( p => name.matches( p ) ) ) ){
    println( "deleting; "+file)
    file.deleteRecurse()
  }

  println()
  println("Unzipping plugins that contain resources that cannot be zipped")

// unzip plugins that need to be unzipped because they contain jars or other
// required plugins
  for(jar <- pluginsDir.listFiles; name = jar.getName; if(jar.isFile && name.endsWith(".jar")); if( pluginsToUnzip.exists( _.findFirstIn(name).isDefined ) ) ){
    println("unzipping: "+jar)
    val dir = new File( jar.getPath.take( jar.getPath.lastIndexOf(".jar") ) )
    dir.mkdir
    jar.unzip( dir )
    jar.delete
  }
}

for( app <- new File(args(0)).listFiles ) {
  println( "packaging: "+app )
  process( new File( app, "plugins" ) )
}


println ("done")
