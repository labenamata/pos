import 'package:flutter/material.dart';

import 'package:pos_app/constant.dart';
import 'package:pos_app/page/produk/komponen/form_field.dart';

class FormProduk extends StatelessWidget {
  const FormProduk({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.pokokController,
    required this.jualController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController pokokController;
  final TextEditingController jualController;
  final dynamic formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: nameController,
            validator: 'Masukan Nama Produk',
            label: 'Nama Produk *',
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: pokokController,
                  validator: 'Masukan Harga Pokok',
                  label: 'Harga Pokok *',
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: CustomFormField(
                  controller: jualController,
                  validator: 'Masukan Harga Jual',
                  label: 'Harga Jual *',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
