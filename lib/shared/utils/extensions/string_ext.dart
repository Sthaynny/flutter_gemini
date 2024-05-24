extension StringExt on String {
  String get camelToSnakeCase => _camelDivider('_').toLowerCase();

  String get camelToKebabCase => _camelDivider('-').toLowerCase();

  String _camelDivider(String symbol) {
    var auxStr = replaceAllMapped(
      RegExpEnum.caractereSeguidoPorLetraMaisculaOuNumero.exp,
      (Match m) => '$symbol${m.group(0)}',
    );
    auxStr = auxStr.replaceAllMapped(
      RegExpEnum.numeroSeguidoPorLetraMaiuscula.exp,
      (Match m) => '$symbol${m.group(0)}',
    );
    return auxStr;
  }
}

enum RegExpEnum {
  caractereSeguidoPorLetraMaisculaOuNumero,
  numeroSeguidoPorLetraMaiuscula,
}

extension RegExpEnumExt on RegExpEnum {
  RegExp get exp {
    switch (this) {
      case RegExpEnum.caractereSeguidoPorLetraMaisculaOuNumero:
        return RegExp(r'(?<=[a-zA-Z])[A-Z0-9]');
      case RegExpEnum.numeroSeguidoPorLetraMaiuscula:
        return RegExp(r'(?<=[0-9])[A-Z]');
    }
  }
}
