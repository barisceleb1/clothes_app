class Order
{
int? order_id;
int? user_id;
String? selectedItems;
String? deliverySystem;
String? paymentSystem;
String? note;
double? totalAmount;
String? image;
String? status;
DateTime? dateTime;
String? shipmentAddress;
String? phoneNumber;

Order({this.order_id,
      this.user_id,
      this.selectedItems,
      this.deliverySystem,
      this.paymentSystem,
      this.note,
      this.totalAmount,
      this.image,
      this.status,
      this.dateTime,
      this.shipmentAddress,
      this.phoneNumber});

Map<String, dynamic> toJson(String imageSelectedBase64) =>
    {
"order_id":order_id,
"user_id":user_id,
"selectedItems":selectedItems,
"deliverySystem":deliverySystem,
"paymentSystem":paymentSystem,
"note":note,
"totalAmount":totalAmount!.toStringAsFixed(2),
"image":image,
"status":status,
"dateTime":dateTime,
"shipmentAddress":shipmentAddress,
          "phoneNumber":phoneNumber

    }
}