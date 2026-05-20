import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final cartEntries = store.cart.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(Icons.shopping_basket, 'ملخص المشتريات'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartEntries.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = cartEntries[index];
                        final product =
                            store.products.firstWhere((p) => p.id == entry.key);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: NetworkImage(product.imageUrl),
                          ),
                          title: Text(product.title,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          subtitle: Text('الكمية: ${entry.value}'),
                          trailing: Text(
                              '${(product.price * entry.value).toStringAsFixed(2)} \$',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle(Icons.receipt_long, 'تفاصيل الدفع'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow('إجمالي المنتجات',
                            '${store.totalBill.toStringAsFixed(2)} \$'),
                        _buildPriceRow('رسوم التوصيل', '0.00 \$'),
                        const Divider(height: 30),
                        _buildPriceRow('المجموع الكلي',
                            '${store.totalBill.toStringAsFixed(2)} \$',
                            isTotal: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ملاحظة: خدمة الدفع الإلكتروني غير مفعلة حالياً في النسخة التجريبية.',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'شكراً لك! سيتم تفعيل الدفع قريباً في الوافي ستور.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('تأكيد الطلب (قريباً)',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 20 : 16,
                  fontWeight: FontWeight.bold,
                  color: isTotal ? Colors.green : Colors.black)),
        ],
      ),
    );
  }
}
