
import 'package:flutter/material.dart';

/// -----------------------------
/// FORM PROVIDER
/// -----------------------------
class FormProviderWidget extends StatefulWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;

  const FormProviderWidget({super.key, required this.child, this.formKey});

  @override
  State<FormProviderWidget> createState() => _FormProviderWidgetState();
}

class _FormProviderWidgetState extends State<FormProviderWidget> {
  final _formValues = <String, dynamic>{};

  void setFieldValue(String name, dynamic value) {
    _formValues[name] = value;
    setState(() {});
  }

  dynamic getFieldValue(String name) => _formValues[name];

  @override
  Widget build(BuildContext context) {
    return _FormContext(
      formValues: _formValues,
      setFieldValue: setFieldValue,
      child: Form(key: widget.formKey, child: widget.child),
    );
  }
}

/// -----------------------------
/// FORM CONTEXT
/// -----------------------------
class _FormContext extends InheritedWidget {
  final Map<String, dynamic> formValues;
  final Function(String name, dynamic value) setFieldValue;

  const _FormContext({
    super.key,
    required Widget child,
    required this.formValues,
    required this.setFieldValue,
  }) : super(child: child);

  static _FormContext of(BuildContext context) {
    final contextWidget = context.dependOnInheritedWidgetOfExactType<_FormContext>();
    if (contextWidget == null) {
      throw Exception('useFormField must be inside FormProviderWidget');
    }
    return contextWidget;
  }

  @override
  bool updateShouldNotify(covariant _FormContext oldWidget) =>
      oldWidget.formValues != formValues;
}

/// -----------------------------
/// FORM FIELD
/// -----------------------------
class FormFieldWidget<T> extends StatefulWidget {
  final String name;
  final T? initialValue;
  final Widget Function(FormFieldState<T> field) builder;
  final String? Function(T?)? validator;

  const FormFieldWidget({
    super.key,
    required this.name,
    required this.builder,
    this.initialValue,
    this.validator,
  });

  @override
  State<FormFieldWidget<T>> createState() => _FormFieldWidgetState<T>();
}

class _FormFieldWidgetState<T> extends State<FormFieldWidget<T>> {
  late T? _value;
  String? _error;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _error = null;
  }

  void _onChanged(T? value) {
    setState(() {
      _value = value;
      if (widget.validator != null) {
        _error = widget.validator!(value);
      }
      _FormContext.of(context).setFieldValue(widget.name, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(FormFieldState<T>(
      value: _value,
      onChanged: _onChanged,
      error: _error,
    ));
  }
}

/// -----------------------------
/// FORM FIELD STATE
/// -----------------------------
class FormFieldState<T> {
  final T? value;
  final void Function(T? value) onChanged;
  final String? error;

  FormFieldState({
    required this.value,
    required this.onChanged,
    required this.error,
  });
}

/// -----------------------------
/// FORM ITEM
/// -----------------------------
class FormItem extends StatelessWidget {
  final Widget child;
  final String? id;

  const FormItem({super.key, required this.child, this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: id != null ? Key(id!) : null,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: child,
    );
  }
}

/// -----------------------------
/// FORM LABEL
/// -----------------------------
class FormLabel extends StatelessWidget {
  final String text;
  final bool error;

  const FormLabel({super.key, required this.text, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: error ? Colors.red : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// -----------------------------
/// FORM CONTROL
/// -----------------------------
class FormControl extends StatelessWidget {
  final Widget child;

  const FormControl({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// -----------------------------
/// FORM DESCRIPTION
/// -----------------------------
class FormDescription extends StatelessWidget {
  final String text;

  const FormDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

/// -----------------------------
/// FORM MESSAGE
/// -----------------------------
class FormMessage extends StatelessWidget {
  final String? error;

  const FormMessage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (error == null || error!.isEmpty) return const SizedBox.shrink();
    return Text(
      error!,
      style: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }
}
