import {
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsEnum([
    'Listo para empezar',
    'En curso',
    'Detenido',
    'Pendiente',
    'Terminado',
  ])
  status?: string;

  @IsOptional()
  @IsEnum(['Critica', 'Alta', 'Media', 'Baja', 'Maximo esfuerzo'])
  priority?: string;

  @IsNotEmpty()
  userId: string; // ID del usuario dueño de la tarea
}
