import 'package:flutter/material.dart';

import '../models/product/product_model.dart';

Widget buildCategoryProduct(ProductModel product, Color bgColor) {
  return Stack(
    children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade400,
                    child: Icon(Icons.image, size: 60, color: Colors.grey.shade500),
                  );
                },
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black87
                    ),
                  maxLines: 2,
                ),

                const SizedBox(height: 2),

                Text(
                    product.brand,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        color: Colors.cyan
                    ),
                    maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],

            )
          ]
      ),


      // Positioned(
      //     bottom: 70,
      //     right: 10,
      //     child: Container(
      //         padding: const EdgeInsets.all(4),
      //         decoration: const BoxDecoration(
      //             color: Color(0xFF00E5CC),
      //             shape: BoxShape.circle
      //         ),
      //         child: const Icon(
      //             Icons.add,
      //             color: Colors.black45,
      //             size: 20
      //         )
      //     )
      // ),
    ],
  );
}