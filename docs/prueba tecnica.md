# Prueba Técnica – Ingeniero de Desarrollo Front-End

## Caso de negocio: Manejo de Fondos (FPV/FIC) para clientes BTG

**Objetivo:** Diseñar e implementar una aplicación web interactiva y responsiva que permita a un usuario final realizar las siguientes acciones:

### Requisitos funcionales
1. **Visualizar** la lista de fondos disponibles.
2. **Suscribirse** a un fondo, siempre que se cumpla con el monto mínimo requerido.
3. **Cancelar** su participación en un fondo y visualizar el saldo actualizado.
4. **Visualizar el historial** de transacciones (incluyendo suscripciones y cancelaciones).
5. **Seleccionar método de notificación** (Email o SMS) al realizar una suscripción.
6. **Mostrar mensajes de error** apropiados si el usuario no cuenta con saldo suficiente.

### Requisitos técnicos
* **Framework:** Usar **Flutter** (preferido) o Angular.
* **UI/UX:** Utilizar buenas prácticas de diseño de interfaz y experiencia de usuario.
* **Manejo de estado:** Implementar soluciones como Provider, Riverpod o BLoC (en Flutter) o servicios y observables (en Angular).
* **Formularios:** Validaciones de formularios pertinentes.
* **Diseño:** Responsivo y con una experiencia de usuario clara.
* **Consumo de datos:** Desde una API REST simulada (se permite el uso de mocks locales o `json-server`).
* **Feedback visual:** Manejo adecuado de errores, estados de carga (*loading states*) y retroalimentación al usuario.
* **Calidad de código:** Código limpio, estructurado y debidamente comentado.

### Extras valorados (no obligatorios)
* Pruebas unitarias de componentes (Flutter Test o Angular Testing Library).
* Uso de TypeScript (si se opta por Angular).
* Navegación y ruteo (Flutter Navigator 2.0 o Angular Router).
* Creación y uso de componentes y widgets reutilizables.

> *Internal Use Only*

---

### Consideraciones
* No es necesario implementar lógica de backend real, autenticación ni despliegue en servidor.
* Se asume un **usuario único** con un saldo inicial de **COP $500.000**.

#### Fondos disponibles
| ID | Nombre | Monto Mínimo | Categoría |
|:---:|:---|:---|:---:|
| 1 | FPV_BTG_PACTUAL_RECAUDADORA | COP $75.000 | FPV |
| 2 | FPV_BTG_PACTUAL_ECOPETROL | COP $125.000 | FPV |
| 3 | DEUDAPRIVADA | COP $50.000 | FIC |
| 4 | FDO-ACCIONES | COP $250.000 | FIC |
| 5 | FPV_BTG_PACTUAL_DINAMICA | COP $100.000 | FPV |

---

### Entregables
* **Código Fuente:** Aojado en un repositorio público (GitHub, GitLab, etc.).
* **Documentación:** Archivo `README.md` con instrucciones claras de ejecución.
* **Evidencia visual:** Capturas de pantalla o un video corto del funcionamiento de la app (opcional, pero altamente valorado).