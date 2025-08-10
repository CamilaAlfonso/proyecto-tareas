import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  //Crear usuario
  async createUser(dto: CreateUserDto): Promise<{ name: string }> {
    // Verificar si el correo ya está registrado
    const existingUser = await this.userRepository.findOne({
      where: { email: dto.email },
    });
    if (existingUser) {
      throw new Error('El correo electrónico ya está registrado');
    }

    // Hashear la contraseña
    const hashedPassword = await bcrypt.hash(dto.password, 10);

    // Crear el nuevo usuario
    const user = this.userRepository.create({
      ...dto,
      password: hashedPassword,
    });

    // Guardar el usuario en la base de datos
    await this.userRepository.save(user);

    // Devolver solo el nombre del usuario
    return { name: user.name };
  }

  // Verificar las credenciales al iniciar sesión
  async validateUser(email: string, password: string): Promise<User | null> {
    const user = await this.userRepository.findOne({
      where: { email },
    });

    if (!user) {
      return null; // Usuario no encontrado
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Correo o contraseña incorrectos');
    }
    return user; // Credenciales correctas
  }
}
