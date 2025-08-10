import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TasksService } from './tasks.service';
import { TasksController } from './tasks.controller';
import { Task } from './task.entity';
import { TaskLog } from './task-log.entity'; // Importamos TaskLog
import { TaskUpdate } from './task-update.entity';
import { User } from '../users/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Task, User, TaskLog, TaskUpdate])],
  controllers: [TasksController],
  providers: [TasksService],
})
export class TasksModule {}
