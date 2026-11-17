import '/components/ingredient_chip/ingredient_chip_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_widget.dart' show ProductDetailWidget;
import 'package:flutter/material.dart';

class ProductDetailModel extends FlutterFlowModel<ProductDetailWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for IngredientChip.
  late IngredientChipModel ingredientChipModel1;
  // Model for IngredientChip.
  late IngredientChipModel ingredientChipModel2;
  // Model for IngredientChip.
  late IngredientChipModel ingredientChipModel3;

  @override
  void initState(BuildContext context) {
    ingredientChipModel1 = createModel(context, () => IngredientChipModel());
    ingredientChipModel2 = createModel(context, () => IngredientChipModel());
    ingredientChipModel3 = createModel(context, () => IngredientChipModel());
  }

  @override
  void dispose() {
    ingredientChipModel1.dispose();
    ingredientChipModel2.dispose();
    ingredientChipModel3.dispose();
  }
}
