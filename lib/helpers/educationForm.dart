class EducationForm {
  static transform(educationFormName) {
    switch (educationFormName) {
      case 1:
        {
          return "Очная форма";
        }
      case 2:
        {
          return "Очно-заочная форма";
        }
      case 3:
        {
          return "Заочная форма";
        }
      default:
        {
          return "Форма неопределена";
        }
    }
  }
}
