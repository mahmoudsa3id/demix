import 'package:equatable/equatable.dart';
class OrderItemSnapshot extends Equatable {
 const OrderItemSnapshot({required this.productId,required this.businessId,required this.categoryId,required this.name,required this.nameAr,required this.imageUrl,required this.quantity,required this.unitPrice,required this.lineTotal});
 final String productId,businessId,categoryId,name; final String? nameAr,imageUrl; final int quantity; final double unitPrice,lineTotal;
 Map<String,dynamic> toMap()=>{'productId':productId,'businessId':businessId,'categoryId':categoryId,'name':name,'nameAr':nameAr,'imageUrl':imageUrl,'quantity':quantity,'unitPrice':unitPrice,'lineTotal':lineTotal};
 @override List<Object?> get props=>[productId,businessId,categoryId,name,nameAr,imageUrl,quantity,unitPrice,lineTotal];
}
