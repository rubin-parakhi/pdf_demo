import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PdfPage(),
    );
  }
}

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  var htmlString = """
  <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <style>
            html, body {
              width: 100%;
              height: 100%;
            }
            </style>
        </head>
    <body>   
        <button id="prev">Prev</button>
        <button id="next">Next</button>
        <span id="npages">not yet</span>
        <div>
            <canvas style="width: 100%; height: 100%;" id="cnv"></canvas>
        </div>
            
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.min.js"></script> 
        <script>
          const PDFStart = nameRoute => {           
          let loadingTask = pdfjsLib.getDocument(nameRoute),
          pdfDoc = null,
          canvas = document.querySelector('#cnv'),
          ctx = canvas.getContext('2d'),
          scale = 1.5,
          numPage = 1;

          const GeneratePDF = numPage => {

            pdfDoc.getPage(numPage).then(page => {

                let viewport = page.getViewport({ scale: scale });
                    canvas.height = viewport.height;
                    canvas.width = viewport.width;
                
                let renderContext = {
                    canvasContext : ctx,
                    viewport:  viewport
                }

                page.render(renderContext);
            })
            document.querySelector('#npages').innerHTML = numPage;

        }

        const PrevPage = () => {
            if(numPage === 1){
                return
            }
            numPage--;
            GeneratePDF(numPage);
        }

        const NextPage = () => {
            if(numPage >= pdfDoc.numPages){
                return
            }
            numPage++;
            GeneratePDF(numPage);
        }

        document.querySelector('#prev').addEventListener('click', PrevPage)
        document.querySelector('#next').addEventListener('click', NextPage )

        loadingTask.promise.then(pdfDoc_ => {
            pdfDoc = pdfDoc_;
            document.querySelector('#npages').innerHTML = pdfDoc.numPages;
            GeneratePDF(numPage)
        });
}

const startPdf = () => {
    PDFStart('https://s3-us-west-2.amazonaws.com/fuse-ai-resources-dev/studentsubmittedassignments/5fe17ca137ba3100574f369f/5ec26c75dde4210042211259/5fe4030af8228f004e0c24005fabcfeb02434f004277ee97Virtualization_Chapter_week_5.pdf')
}

window.addEventListener('load', startPdf);
        </script>
    </body>
  </html>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      // url: new Uri.dataFromString(htmlString, mimeType: 'text/html').toString(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // padding: EdgeInsets.only(right: 10),
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: htmlString),
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
      ),
    );
  }
}
