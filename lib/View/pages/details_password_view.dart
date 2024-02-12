import 'package:flutter/material.dart';
import 'package:strong_password/View/component/costum_button.dart';

class PasswordDetailsView extends StatelessWidget {
  const PasswordDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Details'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: const CostumTextFormPassDetails(
                      labelText: 'Enter password label',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ],
              ),
              const CostumTextFormPassDetails(
                labelText: 'Enter password name',
              ),
              const CostumTextFormPassDetails(
                labelText: 'Enter password',
              ),
              const CostumTextFormPassDetails(
                labelText: 'Enter username',
              ),
              const CostumTextFormPassDetails(
                labelText: 'Enter website',
              ),
              const CostumTextFormPassDetails(
                labelText: 'Enter notes',
              ),
              CostumButton(onPressed: () {}, buttonText: 'Save')
            ],
          ),
        ),
      ),
    );
  }
}

class CostumTextFormPassDetails extends StatelessWidget {
  const CostumTextFormPassDetails({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
