package org.talend.sdi.workspace.spatial;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Platform;
import org.eclipse.ui.IStartup;

/**
 * SDI components require the .spatial directory to be in the workspace so this
 * plugin ensures that it is there on startup
 * 
 * @author jeichar
 */
public class CopySpatialDir implements IStartup {

	public void earlyStartup() {
		URL workspaceURL = Platform.getInstanceLocation().getURL();

		try {
			File workspace = new File(FileLocator.toFileURL(workspaceURL)
					.getFile(), ".spatial");
			File spatialDir = new File(FileLocator.toFileURL(
					Activator.getDefault().getBundle().getEntry(".spatial"))
					.getFile());
			if (!workspace.exists()) {
				copyDirectory(spatialDir, workspace);
			}
		} catch (IOException e) {
			System.err.println("Can't add Directory");
		}
	}

	public void copyDirectory(File sourceLocation, File targetLocation)
			throws IOException {

		if (sourceLocation.isDirectory()) {
			if (!targetLocation.exists()) {
				targetLocation.mkdir();
			}

			String[] children = sourceLocation.list();
			for (int i = 0; i < children.length; i++) {
				copyDirectory(new File(sourceLocation, children[i]), new File(
						targetLocation, children[i]));
			}
		} else {

			InputStream in = new FileInputStream(sourceLocation);
			OutputStream out = new FileOutputStream(targetLocation);

			// Copy the bits from instream to outstream
			byte[] buf = new byte[1024];
			int len;
			while ((len = in.read(buf)) > 0) {
				out.write(buf, 0, len);
			}
			in.close();
			out.close();
		}
	}

}
