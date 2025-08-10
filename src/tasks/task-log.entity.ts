import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Task } from './task.entity';

@Entity('task_logs')
export class TaskLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Task, (task) => task.logs, { onDelete: 'CASCADE' })
  task: Task;

  @Column({ type: 'date' })
  date: string;

  @Column({ type: 'float' })
  hours: number;
}
