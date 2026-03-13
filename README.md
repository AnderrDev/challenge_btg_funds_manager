# BTG Funds Manager 

BTG Funds Manager es una aplicación móvil moderna y elegante diseñada para la gestión de fondos de inversión (FIC y FPV). Permite a los usuarios visualizar su saldo, explorar fondos disponibles, suscribirse a nuevos productos y gestionar sus suscripciones activas.

## Características Principales

- **Dashboard de Inversión**: Visualización clara del saldo disponible y fondos destacados.
- **Exploración de Fondos**: Listado detallado de fondos FIC y FPV con niveles de riesgo y rentabilidad.
- **Gestión de Suscripciones**: Flujo intuitivo para suscribirse y cancelar fondos.
- **Historial de Transacciones**: Registro completo con filtros avanzados por nombre y tipo.
- **Persistencia de Datos**: Los datos se mantienen seguros localmente usando `shared_preferences`.
- **Diseño Premium**: UI refinada con animaciones Hero y feedback visual instantáneo.

## Arquitectura y Tecnologías

El proyecto sigue los principios de **Clean Architecture** y **SOLID** para garantizar escalabilidad y mantenibilidad.

### Capas:
- **Core**: Utilidades, temas, router (GoRouter) e inyección de dependencias (GetIt).
- **Features**:
    - **Data**: Implementación de repositorios y fuentes de datos.
    - **Domain**: Entidades, contratos de repositorios y casos de uso.
    - **Presentation**: UI (Widgets/Pages) y gestión de estado con **BLoC**.

### Tecnologías:
- **Flutter & Dart**
- **BLoC** (Gestión de estado)
- **GoRouter** (Navegación declarativa)
- **GetIt** (Inyección de dependencias)
- **Mocktail** (Testing)

## Requisitos Previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.6.0)
- [Node.js](https://nodejs.org/) (Para el servidor bockend de prueba)
- [Git](https://git-scm.com/)

## Guía de Inicio Rápido

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/btg_funds_manager.git
cd btg_funds_manager
```

### 2. Configurar el Backend
Navega a la carpeta del servidor e instala las dependencias:
```bash
cd server
npm install
npm start
```
*El servidor correrá en `http://localhost:3000`*

### 3. Configurar la App Flutter
En una nueva terminal, instala las dependencias:
```bash
flutter pub get
```

### 4. Correr la Aplicación
```bash
flutter run
```

## Pruebas
Para ejecutar los tests unitarios y de integración:
```bash
flutter test
```

