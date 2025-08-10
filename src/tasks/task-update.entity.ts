import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';
import { Task } from './task.entity';

@Entity('task_updates')
export class TaskUpdate {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Task, (task) => task.updates, { onDelete: 'CASCADE' })
  task: Task;

  @Column({ type: 'text' })
  message: string;

  @CreateDateColumn()
  createdAt: Date;
}
