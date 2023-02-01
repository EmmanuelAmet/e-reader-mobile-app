import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key, required this.files, required this.onOpenedFile}) : super(key: key);
  final List<PlatformFile> files;
  final ValueChanged<PlatformFile> onOpenedFile;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
      ),
      body: Center(
        child: GridView.builder(
          padding: EdgeInsets.all(12.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0
          ),
          itemCount: widget.files.length,
          itemBuilder: (context, index){
            final file = widget.files[index];
            return buildFile(file);
          },
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file){
    return InkWell(
      onTap: () => widget.onOpenedFile(file),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                child: Text('AA'),
              ),
            ),
            Text(file.name)
          ],
        ),
      ),
    );
  }
}

