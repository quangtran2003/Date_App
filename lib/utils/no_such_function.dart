//Xử lý khi xảy ra exception
mixin NoSuchFuntion {
  noSuchFunction(Invocation invocation, Future Function(List) function) {
    if (!invocation.isMethod || invocation.namedArguments.isNotEmpty) {
      super.noSuchMethod(invocation);
    }
    final arguments = invocation.positionalArguments;
    return function(arguments);
  }
}
