import 'package:flutter/material.dart';
import 'package:minpa_lite/controller/auth_controlller.dart'; // Asumsi path ini benar
import 'package:form_builder_validators/form_builder_validators.dart'; // Impor validator

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.con, required this.isRegis});
  final AuthControlller con;
  final bool isRegis;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _obscureTextPassword = true;
  bool _isEmailValid = false; // Contoh state untuk menampilkan ikon centang

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 24.0, vertical: 16.0), // Padding disesuaikan
      child: widget.isRegis == false
          ? Form(
              key: widget.con.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Agar label rata kiri
                  children: [
                    // Field Email (Mirip "ID Cabang")
                    const Text(
                      'Email (ID Pengguna)', // Label di atas field
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con
                          .emailController, // Ganti dengan controller yang sesuai
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText:
                            'contoh@email.com', // Hint text seperti di gambar
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Colors.grey),
                        suffixIcon: _isEmailValid
                            ? const Icon(Icons.check_circle_outline,
                                color: Colors.green)
                            : null, // Ikon centang jika valid
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Email tidak boleh kosong'),
                        FormBuilderValidators.email(
                            errorText: 'Format email tidak valid'),
                      ]),
                      onChanged: (value) {
                        // Contoh sederhana untuk menampilkan ikon centang
                        // Anda mungkin ingin logika yang lebih canggih berdasarkan hasil validasi form
                        setState(() {
                          final isValid =
                              FormBuilderValidators.email().call(value) ==
                                      null &&
                                  value.isNotEmpty;
                          _isEmailValid = isValid;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Field Password
                    const Text(
                      'Password', // Label di atas field
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con.passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _obscureTextPassword,
                      decoration: InputDecoration(
                        hintText: '',
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
                            });
                          },
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Password tidak boleh kosong'),
                        FormBuilderValidators.minLength(6,
                            errorText: 'Password minimal 6 karakter'),
                      ]),
                    ),

                    const SizedBox(height: 24),

                    // --- Field Lainnya (Contoh: Name & Phone dengan gaya serupa) ---
                    // Anda bisa menerapkan gaya serupa ke field lainnya
                    // Field Name
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con.nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama lengkap Anda',
                        prefixIcon:
                            Icon(Icons.badge_outlined, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // ... border lainnya
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      validator: FormBuilderValidators.required(
                          errorText: 'Nama tidak boleh kosong'),
                    ),
                    const SizedBox(height: 24),

                    // Field Phone
                    const Text(
                      'Nomor Telepon',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con.phoneController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nomor telepon Anda',
                        prefixIcon:
                            Icon(Icons.phone_outlined, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // ... border lainnya
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Nomor telepon tidak boleh kosong'),
                        FormBuilderValidators.numeric(
                            errorText: 'Hanya boleh angka'),
                      ]),
                    ),
                    const SizedBox(height: 24),

                    // Field Bank (jika masih digunakan)
                    const Text(
                      'Bank',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con.bankController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: BCA, Mandiri',
                        prefixIcon: Icon(Icons.account_balance_outlined,
                            color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // ... border lainnya
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      validator: FormBuilderValidators.required(
                          errorText: 'Bank tidak boleh kosong'),
                    ),
                    const SizedBox(height: 24),

                    // Field Account Number (jika masih digunakan)
                    const Text(
                      'Nomor Rekening',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.con.accountController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nomor rekening',
                        prefixIcon: Icon(Icons.credit_card_outlined,
                            color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // ... border lainnya
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Nomor rekening tidak boleh kosong'),
                        FormBuilderValidators.numeric(
                            errorText: 'Hanya boleh angka'),
                      ]),
                    ),
                    // const SizedBox(height: 40), // Spasi sebelum tombol

                    // // Tombol Submit (Contoh)
                    // Center(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Theme.of(context).primaryColor, // Warna tombol
                    //       padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    //       textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       )
                    //     ),
                    //     onPressed: () {
                    //       if (widget.con.formKey.currentState!.validate()) {
                    //         // Proses data
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Data sedang diproses...')),
                    //         );
                    //         // Akses data: widget.con.emailController.text, dll.
                    //       } else {
                    //          ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Harap isi semua field dengan benar')),
                    //         );
                    //       }
                    //     },
                    //     child: const Text('LOGIN', style: TextStyle(color: Colors.white)), // Contoh teks tombol
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : Form(
              key: widget.con.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email (ID Pengguna)', // Label di atas field
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: widget.con
                        .emailController, // Ganti dengan controller yang sesuai
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText:
                          'contoh@email.com', // Hint text seperti di gambar
                      prefixIcon:
                          const Icon(Icons.person_outline, color: Colors.grey),
                      suffixIcon: _isEmailValid
                          ? const Icon(Icons.check_circle_outline,
                              color: Colors.green)
                          : null, // Ikon centang jika valid
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Email tidak boleh kosong'),
                      FormBuilderValidators.email(
                          errorText: 'Format email tidak valid'),
                    ]),
                    onChanged: (value) {
                      // Contoh sederhana untuk menampilkan ikon centang
                      // Anda mungkin ingin logika yang lebih canggih berdasarkan hasil validasi form
                      setState(() {
                        final isValid =
                            FormBuilderValidators.email().call(value) == null &&
                                value.isNotEmpty;
                        _isEmailValid = isValid;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Field Password
                  const Text(
                    'Password', // Label di atas field
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: widget.con.passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _obscureTextPassword,
                    decoration: InputDecoration(
                      hintText: '',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Password tidak boleh kosong'),
                      FormBuilderValidators.minLength(6,
                          errorText: 'Password minimal 6 karakter'),
                    ]),
                  ),
                ],
              )),
    );
  }
}
