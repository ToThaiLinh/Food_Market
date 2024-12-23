import 'package:flutter/material.dart';

import '../../../services/recipe_api_service.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({Key? key}) : super(key: key);

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _htmlContentController = TextEditingController();

  @override
  void dispose() {
    _foodNameController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _htmlContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo công thức mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _foodNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên món ăn',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên món ăn';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên công thức',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên công thức';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _htmlContentController,
                  decoration: InputDecoration(
                    labelText: 'Nội dung HTML',
                    border: OutlineInputBorder(),
                    helperText: 'Nhập nội dung công thức dạng HTML',
                  ),
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập nội dung HTML';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final RecipeApiService apiService = RecipeApiService();
                        try {
                          String? recipeId = await apiService.createRecipe(
                            foodName: _foodNameController.text,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            htmlContent: _htmlContentController.text,
                          );

                          if (recipeId != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tạo công thức thành công')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Không thể tạo công thức')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi: $e')),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Text('Lưu công thức'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}