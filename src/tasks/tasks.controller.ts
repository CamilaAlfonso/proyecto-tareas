import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { AddTaskLogDto } from './dto/add-task-log.dto';
import { AddTaskUpdateDto } from './dto/add-task-update.dto';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Post()
  create(@Body() dto: CreateTaskDto) {
    return this.tasksService.create(dto);
  }

  @Post(':id/logs')
  addLog(@Param('id') id: string, @Body() dto: AddTaskLogDto) {
    return this.tasksService.addLog(id, dto); // Llama al servicio
  }

  @Post(':id/updates')
  addUpdate(@Param('id') id: string, @Body() dto: AddTaskUpdateDto) {
    return this.tasksService.addUpdate(id, dto); // Llama al servicio
  }

  @Get()
  findAll() {
    return this.tasksService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.tasksService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: UpdateTaskDto) {
    return this.tasksService.update(id, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.tasksService.remove(id);
  }
}
