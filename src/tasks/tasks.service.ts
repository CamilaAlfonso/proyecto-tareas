import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task } from './task.entity';
import { TaskLog } from './task-log.entity'; // Importamos TaskLog
import { TaskUpdate } from './task-update.entity'; // Importamos TaskUpdate
import { User } from '../users/user.entity';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { AddTaskLogDto } from './dto/add-task-log.dto'; // DTO para log de horas
import { AddTaskUpdateDto } from './dto/add-task-update.dto'; // DTO para actualizaciones

@Injectable()
export class TasksService {
  constructor(
    @InjectRepository(Task)
    private taskRepository: Repository<Task>,
    @InjectRepository(TaskLog)
    private logRepository: Repository<TaskLog>,
    @InjectRepository(TaskUpdate)
    private updateRepository: Repository<TaskUpdate>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async create(dto: CreateTaskDto): Promise<Task> {
    const user = await this.userRepository.findOne({
      where: { id: dto.userId },
    });
    if (!user) throw new NotFoundException('Usuario no encontrado');

    const task = this.taskRepository.create({
      ...dto,
      user,
    });

    return this.taskRepository.save(task);
  }

  findAll(): Promise<Task[]> {
    return this.taskRepository.find({ relations: ['user', 'logs', 'updates'] });
  }

  async findOne(id: string): Promise<Task> {
    const task = await this.taskRepository.findOne({
      where: { id },
      relations: ['user', 'logs', 'updates'],
    });
    if (!task) throw new NotFoundException('Tarea no encontrada');
    return task;
  }

  async update(id: string, dto: UpdateTaskDto): Promise<Task> {
    const task = await this.findOne(id);
    Object.assign(task, dto);
    return this.taskRepository.save(task);
  }

  async remove(id: string): Promise<void> {
    const task = await this.findOne(id);
    await this.taskRepository.remove(task);
  }

  // ----- Agregar log de horas -----
  async addLog(taskId: string, dto: AddTaskLogDto): Promise<TaskLog> {
    const task = await this.findOne(taskId);
    const log = this.logRepository.create({
      task,
      date: dto.date,
      hours: dto.hours,
    });
    // Actualizamos las horas totales de la tarea
    task.totalHours = (task.totalHours ?? 0) + dto.hours;
    await this.taskRepository.save(task);
    return this.logRepository.save(log);
  }

  async getLogs(taskId: string): Promise<TaskLog[]> {
    const task = await this.findOne(taskId);
    return this.logRepository.find({
      where: { task: { id: task.id } },
      order: { date: 'ASC' },
    });
  }

  // ----- Agregar actualización/comentario -----
  async addUpdate(taskId: string, dto: AddTaskUpdateDto): Promise<TaskUpdate> {
    const task = await this.findOne(taskId);
    const update = this.updateRepository.create({
      task,
      message: dto.message,
    });
    return this.updateRepository.save(update);
  }

  async getUpdates(taskId: string): Promise<TaskUpdate[]> {
    const task = await this.findOne(taskId);
    return this.updateRepository.find({
      where: { task: { id: task.id } },
      order: { createdAt: 'ASC' },
    });
  }
}
