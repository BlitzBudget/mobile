/// Authentication Page Regular Expresiion validations
RegExp passwordExp = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
RegExp emailExp = RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");
