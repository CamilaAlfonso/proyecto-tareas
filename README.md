
Un sistema completo de gestión de tareas desarrollado con **NestJS** (backend) y **Flutter** (frontend móvil), utilizando **PostgreSQL** como base de datos.

## 🎯 Descripción del Proyecto

Este proyecto implementa un gestor de tareas completo que permite a los usuarios:

- **Registrarse e iniciar sesión** con autenticación segura
- **Crear, editar y eliminar tareas** con diferentes prioridades y estados
- **Gestionar logs y actualizaciones** de cada tarea
- **Acceder desde dispositivos móviles** mediante la aplicación Flutter

## 🏗️ Arquitectura del Sistema

### Backend (NestJS)
- **Framework**: NestJS con TypeScript
- **Base de datos**: PostgreSQL con TypeORM
- **Autenticación**: bcryptjs para hash de contraseñas
- **Validación**: class-validator para DTOs
- **Documentación**: Swagger/OpenAPI

### Frontend (Flutter)
- **Framework**: Flutter con Dart
- **HTTP Client**: http package para comunicación con API
- **UI**: Material Design
- **Logging**: logger package para debugging

## 🚀 Instalación y Configuración

### Prerrequisitos
- Node.js (v18 o superior)
- PostgreSQL (v12 o superior)
- Flutter SDK (v3.8.1 o superior)
- Android Studio / Xcode (para desarrollo móvil)

### 1. Configuración de la Base de Datos

```sql
-- Crear base de datos
CREATE DATABASE tasksdb;

-- Crear usuario (opcional)
CREATE USER postgres WITH PASSWORD 'tu_contraseña';
GRANT ALL PRIVILEGES ON DATABASE tasksdb TO postgres;
```

### 2. Configuración del Backend

```bash
# Clonar el repositorio
git clone <repository-url>
cd server

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
```

Editar el archivo `.env`:
```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=tu_contraseña
DB_NAME=tasksdb
PORT=3000
```

```bash
# Ejecutar migraciones (opcional, las tablas se crean automáticamente)
npm run start:dev
```

### 3. Configuración del Frontend

```bash
cd task_manager

# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run
```

## 📡 API Endpoints

### Autenticación

#### POST `/users`
Registrar un nuevo usuario
```json
{
  "name": "Usuario Ejemplo",
  "email": "usuario@ejemplo.com",
  "password": "Contraseña123"
}
```

#### POST `/users/login`
Iniciar sesión
```json
{
  "email": "usuario@ejemplo.com",
  "password": "Contraseña123"
}
```

### Tareas

#### GET `/tasks`
Obtener todas las tareas

#### POST `/tasks`
Crear una nueva tarea
```json
{
  "title": "Tarea de ejemplo",
  "description": "Descripción de la tarea",
  "status": "Pendiente",
  "priority": "Media",
  "userId": "uuid-del-usuario"
}
```

#### GET `/tasks/:id`
Obtener una tarea específica

#### PATCH `/tasks/:id`
Actualizar una tarea
```json
{
  "title": "Título actualizado",
  "status": "En curso"
}
```

#### DELETE `/tasks/:id`
Eliminar una tarea

### Logs y Actualizaciones

#### POST `/tasks/:id/logs`
Agregar log a una tarea
```json
{
  "action": "Iniciado trabajo",
  "details": "Se comenzó a trabajar en la tarea"
}
```

#### POST `/tasks/:id/updates`
Agregar actualización a una tarea
```json
{
  "fieldName": "status",
  "oldValue": "Pendiente",
  "newValue": "En curso"
}
```

## 🗄️ Estructura de la Base de Datos

### Tabla `users`
- `id` (UUID, Primary Key)
- `name` (VARCHAR, NOT NULL)
- `email` (VARCHAR, UNIQUE, NOT NULL)
- `password` (VARCHAR, NOT NULL) - Hash bcrypt

### Tabla `tasks`
- `id` (UUID, Primary Key)
- `title` (VARCHAR(200), NOT NULL)
- `description` (TEXT, nullable)
- `status` (ENUM: 'Listo para empezar', 'En curso', 'Detenido', 'Pendiente', 'Terminado')
- `priority` (ENUM: 'Critica', 'Alta', 'Media', 'Baja', 'Maximo esfuerzo')
- `totalHours` (FLOAT, default: 0)
- `userId` (UUID, Foreign Key)
- `createdAt` (TIMESTAMP)
- `updatedAt` (TIMESTAMP)

### Tabla `task_logs`
- `id` (UUID, Primary Key)
- `action` (VARCHAR, NOT NULL)
- `details` (TEXT)
- `timestamp` (TIMESTAMP)
- `taskId` (UUID, Foreign Key)

### Tabla `task_updates`
- `id` (UUID, Primary Key)
- `fieldName` (VARCHAR, NOT NULL)
- `oldValue` (TEXT)
- `newValue` (TEXT)
- `timestamp` (TIMESTAMP)
- `taskId` (UUID, Foreign Key)

## 🔧 Decisiones Técnicas

### Backend
1. **TypeORM con PostgreSQL**: Elección robusta para ORM con soporte completo de TypeScript
2. **UUID como Primary Keys**: Mejor para distribuir y escalar la aplicación
3. **bcryptjs para hash**: Algoritmo seguro y probado para contraseñas
4. **DTOs con validación**: class-validator para validación de entrada
5. **Sincronización manual**: `synchronize: false` para control total del esquema

### Frontend
1. **Flutter para cross-platform**: Desarrollo nativo para iOS y Android
2. **HTTP package**: Cliente HTTP simple y eficiente
3. **Material Design**: UI consistente y moderna
4. **Logging estructurado**: Para debugging y monitoreo

### Seguridad
1. **Hash de contraseñas**: bcrypt con salt rounds
2. **Validación de entrada**: DTOs con reglas estrictas
3. **Relaciones de base de datos**: CASCADE DELETE para integridad referencial

## 🤖 Uso de IA en el Desarrollo

Este proyecto fue desarrollado con la ayuda de **Cursor AI**, un asistente de programación que facilitó:

### Resolución de Problemas
- **Diagnóstico de errores de autenticación**: Identificación de problemas con variables de entorno
- **Corrección de entidades TypeORM**: Solución de problemas con decoradores `@Column()`
- **Limpieza de base de datos**: Scripts para resolver inconsistencias de datos

### Mejoras de Código
- **Validación de contraseñas**: Unificación de reglas entre frontend y backend
- **Manejo de errores**: Implementación de logs de debug y mejor UX
- **Documentación**: Generación automática de README y comentarios

### Optimizaciones
- **Configuración de entorno**: Setup automático de variables de entorno
- **Estructura de base de datos**: Diseño optimizado de tablas y relaciones
- **API RESTful**: Implementación de endpoints siguiendo mejores prácticas

### Beneficios del Uso de IA
- **Desarrollo más rápido**: Resolución inmediata de problemas comunes
- **Código más limpio**: Sugerencias de mejores prácticas
- **Documentación completa**: Generación automática de documentación
- **Debugging eficiente**: Identificación rápida de errores

## 🧪 Testing

```bash
# Backend tests
npm run test
npm run test:e2e

# Frontend tests
cd task_manager
flutter test
```

## 📝 Scripts Disponibles

### Backend
- `npm run start:dev` - Desarrollo con hot reload
- `npm run build` - Compilar para producción
- `npm run start:prod` - Ejecutar en producción
- `npm run test` - Ejecutar tests unitarios
- `npm run test:e2e` - Ejecutar tests end-to-end

### Frontend
- `flutter run` - Ejecutar en modo desarrollo
- `flutter build apk` - Construir APK para Android
- `flutter build ios` - Construir para iOS

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request



## 👥 Autor

Maria Camila Alfonso

---
<img width="500" height="100" alt="image" src="https://github.com/user-attachments/assets/aa413c88-eb65-48c4-b071-45a8ff66ecba" />

<img width="500" height="100" alt="image" src="https://github.com/user-attachments/assets/f95a36c4-8705-429c-bdf1-916882fedfd3" />

<img width="569" height="100" alt="image" src="https://github.com/user-attachments/assets/a49a1284-2d5e-4be7-aaf5-b9a2f14b68c7" />

<img width="592" height="100" alt="image" src="https://github.com/user-attachments/assets/87e595ef-bfb8-42d9-afa6-b4c81c04c045" />

<img width="569" height="100" alt="image" src="https://github.com/user-attachments/assets/d546bb1a-3a70-4c11-b017-8cea5b4be1bf" />

<img width="578" height="100" alt="image" src="https://github.com/user-attachments/assets/0362168c-86ff-4c23-8b1f-8e96e9a3bfdf" />

<img width="548" height="100" alt="image" src="https://github.com/user-attachments/assets/8ad9f051-8552-4db9-95e1-4f5ce588770a" />









