import { Body, Controller, Post } from '@nestjs/common';
import { UsersService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';

@Controller('users')
export class UserController {
  constructor(private readonly usersService: UsersService) {}

  @Post('login')
  async login(@Body() body: { email: string; password: string }) {
    const { email, password } = body;
    const user = await this.usersService.validateUser(email, password);

    if (!user) {
      throw new Error('Credenciales incorrectas');
    }

    return { name: user.name }; // Devuelve solo el nombre del usuario
  }

  @Post()
  async create(@Body() dto: CreateUserDto): Promise<{ name: string }> {
    return this.usersService.createUser(dto); // Crea un nuevo usuario
  }
}
