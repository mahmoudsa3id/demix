import 'package:flutter/material.dart';
import 'package:demix/features/payment/domain/entities/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key, required this.value, required this.onChanged});
  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(children: [
      _PaymentTile(
        selected: value == PaymentMethod.cashOnDelivery,
        icon: Icons.payments_rounded,
        title: 'الدفع عند الاستلام', subtitle: 'ادفع كاش عند وصول طلبك',
        onTap: () => onChanged(PaymentMethod.cashOnDelivery),
      ),
      const SizedBox(height: 10),
      _PaymentTile(
        selected: value == PaymentMethod.visa,
        icon: Icons.credit_card_rounded,
        title: 'Visa', subtitle: 'ادفع بأمان باستخدام بطاقتك',
        onTap: () => onChanged(PaymentMethod.visa),
      ),
      if (value == PaymentMethod.visa) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(20)),
          child: const _VisaForm(),
        ),
      ],
    ]);
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final bool selected; final IconData icon; final String title; final String subtitle; final VoidCallback onTap;
  @override Widget build(BuildContext context) {
    final s=Theme.of(context).colorScheme;
    return Material(color: Colors.transparent, child: InkWell(
      onTap:onTap, borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: selected?s.primaryContainer:s.surface,
          border: Border.all(color:selected?s.primary:s.outlineVariant, width:selected?1.5:1)),
        child: Row(children:[
          Container(width:48,height:48,decoration:BoxDecoration(color:selected?s.primary:s.surfaceContainerHighest,shape:BoxShape.circle),child:Icon(icon,color:selected?s.onPrimary:s.onSurfaceVariant)),
          const SizedBox(width:12), Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:3),Text(subtitle,style:TextStyle(fontSize:12,color:s.onSurfaceVariant))])),
          AnimatedContainer(duration:const Duration(milliseconds:180),width:22,height:22,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:selected?s.primary:s.outline,width:2)),child:selected?Center(child:Container(width:10,height:10,decoration:BoxDecoration(color:s.primary,shape:BoxShape.circle))):null),
        ]),
      ),
    ));
  }
}

class _VisaForm extends StatefulWidget { const _VisaForm(); @override State<_VisaForm> createState()=>_VisaFormState(); }
class _VisaFormState extends State<_VisaForm> {
  final number=TextEditingController(), expiry=TextEditingController(), cvv=TextEditingController();
  @override void dispose(){number.dispose();expiry.dispose();cvv.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    final border=OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide(color:Theme.of(context).colorScheme.outlineVariant));
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('بيانات البطاقة',style:Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight:FontWeight.w900)),const SizedBox(height:10),
      TextField(controller:number,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:'رقم البطاقة',prefixIcon:const Icon(Icons.credit_card),border:border)),
      const SizedBox(height:10),Row(children:[Expanded(child:TextField(controller:expiry,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:'MM/YY',border:border))),const SizedBox(width:10),Expanded(child:TextField(controller:cvv,keyboardType:TextInputType.number,obscureText:true,decoration:InputDecoration(labelText:'CVV',border:border)))]),
      const SizedBox(height:8),Text('للتجربة داخل التطبيق فقط — اربط بوابة دفع حقيقية قبل الإنتاج.',style:Theme.of(context).textTheme.bodySmall?.copyWith(color:Theme.of(context).colorScheme.onSurfaceVariant)),
    ]);
  }
}
