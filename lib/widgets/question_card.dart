import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String texto;
  final int? respuestaSeleccionada;
  final bool esInversa;
  final Function(int) onSelected;

  const QuestionCard({
    super.key,
    required this.texto,
    required this.respuestaSeleccionada,
    required this.esInversa,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> etiquetas = ["Nunca", "Casi nunca", "A veces", "A menudo", "Siempre"];
    List<int> valores = esInversa ? [4, 3, 2, 1, 0] : [0, 1, 2, 3, 4];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(texto, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              int valorActual = valores[index];
              bool seleccionado = respuestaSeleccionada == valorActual;

              return GestureDetector(
                onTap: () => onSelected(valorActual),
                child: Column(
                  children: [
                    Text(etiquetas[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.black54)),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 42, width: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: seleccionado ? const Color(0xFF90CAF9) : Colors.white,
                        border: Border.all(color: seleccionado ? Colors.blue : Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text("$valorActual",
                            style: TextStyle(fontWeight: FontWeight.bold, color: seleccionado ? Colors.white : Colors.black87)),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}