import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from '../users/user.entity';
import { TaskLog } from './task-log.entity';
import { TaskUpdate } from './task-update.entity';

@Entity('tasks')
export class Task {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 200 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({
    type: 'enum',
    enum: [
      'Listo para empezar',
      'En curso',
      'Detenido',
      'Pendiente',
      'Terminado',
    ],
    default: 'Pendiente',
  })
  status: string;

  @Column({
    type: 'enum',
    enum: ['Critica', 'Alta', 'Media', 'Baja', 'Maximo esfuerzo'],
    default: 'Media',
  })
  priority: string;

  @Column({ type: 'float', default: 0 })
  totalHours: number;

  @ManyToOne(() => User, (user) => user.tasks, { onDelete: 'CASCADE' })
  user: User;

  @OneToMany(() => TaskLog, (log) => log.task)
  logs: TaskLog[];

  @OneToMany(() => TaskUpdate, (update) => update.task)
  updates: TaskUpdate[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
