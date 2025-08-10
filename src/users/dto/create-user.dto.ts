import { IsEmail, IsNotEmpty, MinLength, Matches } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty({ message: 'El nombre es obligatorio' })
  name: string;

  @IsEmail({}, { message: 'El correo no es válido' })
  email: string;

  @MinLength(6, { message: 'La contraseña debe tener mínimo 6 caracteres' })
  @Matches(/(?=.*[A-Z])/, { message: 'Debe contener al menos una mayúscula' })
  password: string;
}
