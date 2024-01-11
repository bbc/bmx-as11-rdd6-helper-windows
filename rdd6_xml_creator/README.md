# RDD 6 XML Creator

The [SMPTE RDD 6](https://ieeexplore.ieee.org/document/7290141) (Dolby E Audio Metadata) XML Creator is a basic HTML web page application that creates an XML file suitable for `bmxtranswrap` to embed a static RDD 6 serial bitstream in an MXF file.

Open `index.html` in a web browser and fill-in the RDD 6 metadata. Select "Save XML" to export to a local file.

>The file name includes a hash of the file contents and therefore files will have a different name if the contents are different.

The files in this directory are [copied from the bmx repo](https://github.com/bbc/bmx/blob/main/meta/rdd6_xml_creator/).