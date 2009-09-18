#!/bin/sh
exec scala "$0" "$@"
!#

def check( assertion:Boolean, msg:String )={
  if( !assertion ){
    println( msg )
    exit(1)
  }
}


check( args.length==2, """update-product.sh <template .product file> <path to SDI branding product> [containUdig]\nBy default containUdig is true, set to false if you dont want to add the uDig configuration plugin""")

val containUdig = if( args.length == 3 ) ("true" == args(2) || "1" == args(2)) else true

import scala.xml._

val pluginsToUnpack = List(
  """org.talend.libraries.*""".r
)

val brandingFile = args(1)

def copy(node:Node):Option[Node]={
  node match {
    case x if ("plugin" == x.label) =>  None
    case x if ("includes" == x.label) =>  None
    case x if ("features" == x.label) =>  None
    case x if ("product" == x.label) => {
      println("copying plugin definitions from "+args(0))
      val copied = for( n <- node.child ) yield copy(n)
      val udigConfig = <plugins><plugin id="org.talend.sdi.udig"/></plugins>
      val children = copied.filter( _.isDefined).map( _.get) ++ (XML.loadFile(args(0)) \\ "plugins") ++ udigConfig
      Some(Elem(node.prefix, node.label, node.attributes, node.scope, children:_*))
    }
    case Text(t) if( t.trim.isEmpty ) => None
    case other => Some(other)
  }
}

println("copying branding information from "+brandingFile)
val productXml = copy(XML.loadFile(brandingFile)).get


val xmlString = new PrettyPrinter(200,4).format(productXml)
val xmlDec = """<?xml version="1.0" encoding="UTF-8"?>"""

val out = new java.io.File(args(1)).getParentFile+"/exportable.product"

println("writing new product definition to "+out)

val writer=new java.io.FileWriter(out)
writer.write(xmlDec+"\n")
writer.write(xmlString)
writer.close()
