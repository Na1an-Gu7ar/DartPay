import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/payment_model.dart';
import '../models/payment_request.dart';
import '../models/upi_app_model.dart';
import '../providers/auth_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/transaction_provider.dart';
import '../routes/app_routes.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/offline_banner.dart';

// SendMoneyScreen demonstrates real payment paths: UPI Intent and Razorpay Checkout.
class SendMoneyScreen extends StatefulWidget {
  final PaymentRequest? initialRequest;

  const SendMoneyScreen({super.key, this.initialRequest});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController(text: 'SwiftPay transfer');
  UpiAppModel? _selectedUpiApp;
  PaymentRail _selectedRail = PaymentRail.upiIntent;

  @override
  void initState() {
    super.initState();
    _applyInitialRequest(widget.initialRequest);
  }

  @override
  void didUpdateWidget(covariant SendMoneyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRequest != oldWidget.initialRequest) {
      _applyInitialRequest(widget.initialRequest);
    }
  }

  void _applyInitialRequest(PaymentRequest? request) {
    if (request == null) return;
    _upiController.text = request.upiId;
    _nameController.text = request.receiverName;
    if (request.amount > 0) _amountController.text = request.amount.toStringAsFixed(2);
    _noteController.text = request.note;
  }

  @override
  void dispose() {
    _upiController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _startPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final isOnline = context.read<ConnectivityProvider>().isOnline;
    final paymentProvider = context.read<PaymentProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final amount = double.parse(_amountController.text.trim());

    PaymentModel? payment;
    if (_selectedRail == PaymentRail.upiIntent) {
      if (_selectedUpiApp == null) {
        showAppSnackBar(context, 'Select an installed UPI app first', isError: true);
        return;
      }

      // UPI Intent opens another installed app; internet may be handled by that app.
      payment = await paymentProvider.payWithUpiIntent(
        selectedApp: _selectedUpiApp!,
        upiId: _upiController.text.trim(),
        receiverName: _nameController.text.trim(),
        amount: amount,
        note: _noteController.text.trim(),
      );
    } else {
      if (!isOnline) {
        showAppSnackBar(context, 'Connect to internet before opening Razorpay', isError: true);
        return;
      }

      final user = context.read<AuthProvider>().user;
      payment = await paymentProvider.payWithRazorpay(
        upiId: _upiController.text.trim(),
        receiverName: _nameController.text.trim(),
        amount: amount,
        note: _noteController.text.trim(),
        userPhone: user?.phone ?? '9999999999',
        userName: user?.name ?? 'SwiftPay User',
      );
    }

    if (!mounted) return;
    if (payment == null) {
      showAppSnackBar(context, paymentProvider.errorMessage ?? 'Payment could not start', isError: true);
      return;
    }

    if (payment.transaction != null) {
      await transactionProvider.addTransaction(payment.transaction!);
    }

    if (!mounted) return;
    context.push(AppRoutes.success, extra: payment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send money')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose payment method',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Use UPI Intent for installed UPI apps or Razorpay for checkout payments.'),
                    const SizedBox(height: 20),
                    _PaymentRailSelector(
                      selectedRail: _selectedRail,
                      onChanged: (rail) => setState(() => _selectedRail = rail),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _upiController,
                      label: 'Receiver UPI ID',
                      hint: 'name@bank',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.upiId,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Receiver name',
                      hint: 'Merchant or friend name',
                      icon: Icons.person_rounded,
                      validator: (value) => Validators.requiredText(value, 'Receiver name'),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _amountController,
                      label: 'Amount',
                      hint: '500',
                      icon: Icons.currency_rupee_rounded,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.amount,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _noteController,
                      label: 'Note',
                      hint: 'Dinner, rent, shopping...',
                      icon: Icons.notes_rounded,
                      validator: (value) => Validators.requiredText(value, 'Note'),
                    ),
                    const SizedBox(height: 18),
                    if (_selectedRail == PaymentRail.upiIntent)
                      _UpiAppPicker(
                        selectedApp: _selectedUpiApp,
                        onSelected: (app) => setState(() => _selectedUpiApp = app),
                      ),
                    const SizedBox(height: 22),
                    Consumer<PaymentProvider>(
                      builder: (context, provider, child) {
                        return CustomButton(
                          label: _selectedRail == PaymentRail.upiIntent
                              ? 'Pay using UPI app'
                              : 'Open Razorpay checkout',
                          icon: Icons.lock_rounded,
                          isLoading: provider.isLoading,
                          onPressed: _startPayment,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const _SecurityNote(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRailSelector extends StatelessWidget {
  final PaymentRail selectedRail;
  final ValueChanged<PaymentRail> onChanged;

  const _PaymentRailSelector({required this.selectedRail, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PaymentRail>(
      segments: const [
        ButtonSegment(
          value: PaymentRail.upiIntent,
          icon: Icon(Icons.account_balance_rounded),
          label: Text('UPI Intent'),
        ),
        ButtonSegment(
          value: PaymentRail.razorpay,
          icon: Icon(Icons.credit_card_rounded),
          label: Text('Razorpay'),
        ),
      ],
      selected: {selectedRail},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _UpiAppPicker extends StatelessWidget {
  final UpiAppModel? selectedApp;
  final ValueChanged<UpiAppModel> onSelected;

  const _UpiAppPicker({required this.selectedApp, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, provider, child) {
        if (provider.isFetchingUpiApps) {
          return const LinearProgressIndicator();
        }
        if (provider.upiApps.isEmpty) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.warning_rounded),
              title: const Text('No UPI apps detected'),
              subtitle: const Text('Install a UPI app or use Razorpay checkout.'),
              trailing: IconButton(
                onPressed: provider.loadInstalledUpiApps,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Installed UPI apps', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: provider.upiApps.map((app) {
                final isSelected = selectedApp?.packageName == app.packageName;
                return ChoiceChip(
                  label: Text(app.name),
                  selected: isSelected,
                  onSelected: (_) => onSelected(app),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.security_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Learning note: real production apps must verify Razorpay payment signatures on a backend. '
                'Never trust frontend-only payment success for order fulfilment.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
