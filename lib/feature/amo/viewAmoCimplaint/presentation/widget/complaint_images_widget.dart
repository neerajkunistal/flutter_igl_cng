import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintImagesWidget extends StatelessWidget {
  final List<dynamic> imageList;
  const ComplaintImagesWidget({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return imageList.isNotEmpty ?GridView.builder(
      itemCount: imageList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index)  {
        return Container(
          padding: const EdgeInsets.all(8), // Border width
          child: InkWell(
            onTap: () async {
              if(imageList[index].toString().toLowerCase().contains("png") ||
                  imageList[index].toString().toLowerCase().contains("jpg") ||
                  imageList[index].toString().toLowerCase().contains("jpeg")){
                await showDialog(
                    context: context,
                    builder: (_) => ImageDialog(imageUrl: imageList[index].toString(),));
              } else {
                if (!await launchUrl(Uri.parse(imageList[index].toString()))) {
                  throw Exception('Could not launch ${imageList[index].toString()}');
                }
              }

            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(20), // Image radius
                child: imageList[index].toString().toLowerCase().contains("png") ||
                    imageList[index].toString().toLowerCase().contains("jpg") ||
                    imageList[index].toString().toLowerCase().contains("jpeg") ?
                   Image.network(imageList[index].toString(), fit: BoxFit.cover)
                    : imageList[index].toString().toLowerCase().contains("pdf") ?
                    Icon(Icons.picture_as_pdf_outlined, color: AppColor.red,)
                    : Icon(Icons.file_copy_outlined, color: Colors.lightBlue[800],),
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    ) : const Padding(
      padding: EdgeInsets.all(8.0),
      child: TextWidget("No images",),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  const ImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/1.9,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}
