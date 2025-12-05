-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.actividades (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  nombre text NOT NULL,
  fecha date NOT NULL,
  hora time without time zone,
  lugar text,
  descripcion text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT actividades_pkey PRIMARY KEY (id)
);
CREATE TABLE public.donacion_items (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  donacion_id uuid,
  inventario_instalacion_id uuid,
  cantidad integer NOT NULL,
  observaciones text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT donacion_items_pkey PRIMARY KEY (id),
  CONSTRAINT donacion_items_donacion_id_fkey FOREIGN KEY (donacion_id) REFERENCES public.donaciones(id),
  CONSTRAINT donacion_items_inventario_instalacion_id_fkey FOREIGN KEY (inventario_instalacion_id) REFERENCES public.inventario_instalacion(id)
);
CREATE TABLE public.donaciones (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  fecha date NOT NULL DEFAULT CURRENT_DATE,
  donante_nombre text NOT NULL,
  donante_tipo text,
  contacto_info text,
  valor_estimado numeric,
  notas text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT donaciones_pkey PRIMARY KEY (id)
);
CREATE TABLE public.instalaciones (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  nombre text NOT NULL,
  descripcion text,
  estado text DEFAULT 'disponible'::text CHECK (estado = ANY (ARRAY['activa'::text, 'inactiva'::text, 'disponible'::text, 'mantenimiento'::text])),
  created_at timestamp without time zone DEFAULT now(),
  largo numeric,
  ancho numeric,
  capacidad integer,
  tipo text,
  ubicacion character varying,
  CONSTRAINT instalaciones_pkey PRIMARY KEY (id)
);
CREATE TABLE public.inventario (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  nombre text NOT NULL,
  cantidad_actual numeric DEFAULT 0,
  unidad_medida text NOT NULL,
  ubicacion text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT inventario_pkey PRIMARY KEY (id)
);
CREATE TABLE public.inventario_instalacion (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  instalacion_id uuid,
  nombre text NOT NULL,
  cantidad integer DEFAULT 1,
  estado text DEFAULT 'funcional'::text CHECK (estado = ANY (ARRAY['funcional'::text, 'dañado'::text, 'mantenimiento'::text])),
  condicion text,
  observaciones text,
  updated_at timestamp without time zone DEFAULT now(),
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT inventario_instalacion_pkey PRIMARY KEY (id),
  CONSTRAINT inventario_instalacion_instalacion_id_fkey FOREIGN KEY (instalacion_id) REFERENCES public.instalaciones(id)
);
CREATE TABLE public.inventario_movimientos (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  inventario_id uuid,
  tipo text NOT NULL CHECK (tipo = ANY (ARRAY['entrada'::text, 'salida'::text])),
  cantidad integer NOT NULL,
  motivo text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT inventario_movimientos_pkey PRIMARY KEY (id)
);
CREATE TABLE public.mantenimientos_instalacion (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  instalacion_id uuid,
  titulo text NOT NULL,
  descripcion text,
  fecha date NOT NULL,
  estado text NOT NULL,
  responsable text,
  detalles text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT mantenimientos_instalacion_pkey PRIMARY KEY (id),
  CONSTRAINT mantenimientos_instalacion_instalacion_id_fkey FOREIGN KEY (instalacion_id) REFERENCES public.instalaciones(id)
);
CREATE TABLE public.personal (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nombre text,
  apellido text,
  cedula text,
  nacionalidad text,
  telefono text,
  sexo text,
  direccion text,
  nivel_academico text,
  cargo text,
  fecha_registro timestamp with time zone DEFAULT now(),
  activo boolean NOT NULL DEFAULT true,
  CONSTRAINT personal_pkey PRIMARY KEY (id)
);
CREATE TABLE public.reportes (
  id integer NOT NULL DEFAULT nextval('reportes_id_seq'::regclass),
  tipo text,
  fecha date DEFAULT CURRENT_DATE,
  responsable text,
  detalles text,
  CONSTRAINT reportes_pkey PRIMARY KEY (id)
);
CREATE TABLE public.reservas (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  instalacion_id text NOT NULL,
  nombre_completo text NOT NULL,
  telefono text NOT NULL,
  institucion text,
  correo text NOT NULL,
  fecha_inicio date NOT NULL,
  fecha_fin date NOT NULL,
  hora_inicio time without time zone NOT NULL,
  hora_fin time without time zone NOT NULL,
  descripcion text,
  estado text DEFAULT 'pendiente'::text CHECK (estado = ANY (ARRAY['pendiente'::text, 'aprobada'::text, 'rechazada'::text])),
  created_at timestamp without time zone DEFAULT now(),
  user_id uuid,
  CONSTRAINT reservas_pkey PRIMARY KEY (id),
  CONSTRAINT reservas_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.usuarios (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  nombre text NOT NULL,
  email text NOT NULL UNIQUE,
  telefono text,
  rol text NOT NULL CHECK (rol = ANY (ARRAY['externo'::text, 'usuario_administrador'::text, 'administrador'::text])),
  creado_en timestamp without time zone DEFAULT now(),
  activo boolean NOT NULL DEFAULT true,
  nota text,
  CONSTRAINT usuarios_pkey PRIMARY KEY (id)
);