enum AnimationEnum {
  dino,
  loading,
  person;

  const AnimationEnum();

  String get path => 'assets/$name.json';
}
