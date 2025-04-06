import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:d_m/providers/language_provider.dart';

class TranslatableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatableText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
      }) : super(key: key);

  @override
  State<TranslatableText> createState() => _TranslatableTextState();
}

class _TranslatableTextState extends State<TranslatableText> {
  String? _translatedText;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _translateText();
  }

  @override
  void didUpdateWidget(TranslatableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translateText();
    }
  }

  Future<void> _translateText() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final translated = await provider.translateText(widget.text);

    if (mounted) {
      setState(() {
        _translatedText = translated;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Text(
      widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    )
        : Text(
      _translatedText ?? widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}