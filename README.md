# bmx-as11-rdd6-helper-windows

Windows script to embed RDD 6 (Dolby) surround sound metadata in an [AS-11 UK DPP HD file](https://amwa-tv.github.io/AS-11_UK_DPP_HD/AMWA_AS_11_UK_DPP_HD.html), using components of the [bmx suite](https://github.com/bbc/bmx).

Requires [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) to run the included bmx executables. This is often already present as it is commonly used by other Windows applications.

The script checks that the supplied AS-11 UK DPP HD file has the correct audio layout and that it doesn't already include surround sound metadata. Other issues will be reported by the bmx executables.

This repository also includes a copy of the RDD 6 XML Creator web browser application from the [bmx suite](https://github.com/bbc/bmx), which can be used to create the XML surround sound metadata file that the script requires.

## Usage

1. Create an AS-11 file, complete apart from the surround sound metadata
2. Create a surround sound metadata XML file, which can be done with the XML Creator as per its [README](rdd6_xml_creator/README.md)
3. Open the [embed_rdd6.bat](embed_rdd6.bat) script from a File Explorer
4. Choose the AS-11 file
5. Choose the XML file
6. Choose an output filename (one is suggested)
7. Wait until the transwrap completes - a progress indicator is shown
8. Press ENTER to close the window

## Reporting Problems

Please raise an issue in [GitHub](https://github.com/bbc/bmx-as11-rdd6-helper-windows).

## Licence

This script is provided under the BSD 3-Clause licence. See the [COPYING](COPYING) file provided with this library for more details.