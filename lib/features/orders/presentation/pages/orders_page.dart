import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم DefaultTabController لإنشاء واجهة مبوبة (Tabs)
    return DefaultTabController(
      length: 2, // عدد التبويبات: الحالية والسابقة
      child: Scaffold(
        appBar: AppBar(
          title:  Text('طلباتي',style: Theme.of(context).textTheme.bodyLarge,),
        
          // بناء شريط التبويبات (TabBar) في الجزء السفلي من AppBar
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor, 
            labelColor: Theme.of(context).primaryColor,     
            unselectedLabelColor: Colors.grey,            
            tabs: const [
              Tab(text: 'الحالية (2)'), 
              Tab(text: 'السابقة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. شاشة الطلبات الحالية (Current Orders)
            _buildCurrentOrdersTab(context),

            // 2. شاشة الطلبات السابقة (Past Orders)
            _buildPastOrdersTab(context),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء أقسام الطلبات ---

  // بناء تبويب الطلبات الحالية
  Widget _buildCurrentOrdersTab(BuildContext context) {
    // مثال لبيانات طلبات وهمية "حالية"
    final currentOrders = [
      _Order(
        id: 'ORD-101',
        storeName: 'مطعم الشاورما الذهبية',
        status: 'قيد التوصيل',
        date: 'اليوم، 1:30 م',
        total: 55.00,
        statusColor: Colors.orange,
      ),
      _Order(
        id: 'ORD-102',
        storeName: 'سوبر ماركت الوفاء',
        status: 'تم تأكيد الطلب',
        date: 'اليوم، 1:00 م',
        total: 98.50,
        statusColor: Colors.green,
      ),
    ];

    if (currentOrders.isEmpty) {
      return _buildEmptyState('لا توجد طلبات حالية في الوقت الراهن.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: currentOrders.length,
      itemBuilder: (context, index) {
        return _OrderCard(order: currentOrders[index], isCurrent: true);
      },
    );
  }

  // بناء تبويب الطلبات السابقة
  Widget _buildPastOrdersTab(BuildContext context) {
    // مثال لبيانات طلبات وهمية "سابقة"
    final pastOrders = [
      _Order(
        id: 'ORD-099',
        storeName: 'مخبز الأناضول',
        status: 'تم التسليم',
        date: 'أمس، 7:00 م',
        total: 22.00,
        statusColor: Colors.blueGrey,
      ),
      _Order(
        id: 'ORD-098',
        storeName: 'كافيه البن المختص',
        status: 'تم الإلغاء',
        date: '05/12/2025',
        total: 35.00,
        statusColor: Colors.red,
      ),
    ];

    if (pastOrders.isEmpty) {
      return _buildEmptyState('لم تقم بإنهاء أي طلبات سابقة بعد.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: pastOrders.length,
      itemBuilder: (context, index) {
        return _OrderCard(order: pastOrders[index], isCurrent: false);
      },
    );
  }

  // بناء حالة عدم وجود طلبات
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// --- نموذج البيانات (Data Model) ---

class _Order {
  final String id;
  final String storeName;
  final String status;
  final String date;
  final double total;
  final Color statusColor;

  _Order({
    required this.id,
    required this.storeName,
    required this.status,
    required this.date,
    required this.total,
    required this.statusColor,
  });
}

// --- بطاقة الطلب (Order Card Widget) ---

class _OrderCard extends StatelessWidget {
  final _Order order;
  final bool isCurrent;

  const _OrderCard({required this.order, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: الانتقال إلى صفحة تفاصيل الطلب
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('عرض تفاصيل الطلب: ${order.id}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: اسم المتجر ورقم الطلب
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.storeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'رقم الطلب: ${order.id}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Divider(height: 20),
              
              // حالة الطلب والتاريخ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الإجمالي: ${order.total.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        order.date,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  
                  // شارة الحالة (Status Badge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: order.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              // زر الإجراءات (يظهر فقط للطلبات الحالية)
              if (isCurrent) ...[
                const Divider(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: تنفيذ وظيفة تتبع الطلب
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('تتبع الطلب', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
              
              // زر الإجراءات (يظهر فقط للطلبات السابقة)
              if (!isCurrent && order.status == 'تم التسليم') ...[
                const Divider(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: تنفيذ وظيفة إعادة الطلب
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('إعادة الطلب', style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}