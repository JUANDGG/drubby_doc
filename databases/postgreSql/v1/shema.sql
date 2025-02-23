CREATE TABLE "user" (
  "id" serial PRIMARY KEY,
  "name" varchar(50),
  "email" varchar(100),
  "password_hash" varchar(150),
  "state" boolean,
  "id_role" integer
);

CREATE TABLE "role" (
  "id" serial PRIMARY KEY,
  "name" varchar(30),
  "state" boolean
);

CREATE TABLE "permission" (
  "id" serial PRIMARY KEY,
  "name" varchar(30),
  "state" boolean
);

CREATE TABLE "role_permission" (
  "id" serial PRIMARY KEY,
  "id_role" integer,
  "id_permission" integer
);

CREATE TABLE "category" (
  "id" serial PRIMARY KEY,
  "name" varchar(30),
  "state" boolean
);

CREATE TABLE "sub_category" (
  "id" serial PRIMARY KEY,
  "name" varchar(30),
  "state" boolean,
  "id_category" integer
);

CREATE TABLE "item" (
  "id" serial PRIMARY KEY,
  "name" varchar(30)
);

CREATE TABLE "attribute" (
  "id" serial PRIMARY KEY,
  "name" varchar(30)
);

CREATE TABLE "attribute_item" (
  "id" serial PRIMARY KEY,
  "id_attribute" integer,
  "id_item" integer
);

CREATE TABLE "product" (
  "id" serial PRIMARY KEY,
  "name" varchar(30),
  "description" text,
  "unit_price" NUMERIC(10,2),
  "stock" int,
  "state" boolean,
  "creation_date" date,
  "id_sub_category" integer
);

CREATE TABLE "productoImage" (
  "id" serial PRIMARY KEY,
  "url" text,
  "id_product" integer
);

CREATE TABLE "attribute_product" (
  "id" serial PRIMARY KEY,
  "id_product" integer,
  "id_attribute" integer
);

CREATE TABLE "order" (
  "id" serial PRIMARY KEY,
  "id_user" integer,
  "total" NUMERIC(10,2),
  "state" CHECK,
  "payment_status" check,
  "created_at" TIMESTAMP,
  "country" varchar(30),
  "city" varchar(30),
  "region" varchar(30),
  "address" text,
  "postal_code" varchar(20),
  "tracking_number" varchar(50) UNIQUE
);

CREATE TABLE "order_detail" (
  "id" serial PRIMARY KEY,
  "id_order" integer,
  "id_procuct" integer,
  "quantity" integer,
  "price_product" NUMERIC(10,2),
  "discount" numeric(5,2),
  "subtotal" numeric(10,2)
);

CREATE TABLE "payment_method" (
  "id" serial PRIMARY KEY,
  "name" varchar(50),
  "state" boolean
);

CREATE TABLE "payment" (
  "id" serial PRIMARY KEY,
  "id_order" integer,
  "id_payment_method" integer,
  "transaction_id" VARCHAR(100) UNIQUE,
  "amount" NUMERIC(10,2),
  "currency" varchar(6)
);

ALTER TABLE "role_permission" ADD FOREIGN KEY ("id_role") REFERENCES "role" ("id");

ALTER TABLE "role_permission" ADD FOREIGN KEY ("id_permission") REFERENCES "permission" ("id");

ALTER TABLE "sub_category" ADD FOREIGN KEY ("id_category") REFERENCES "category" ("id");

ALTER TABLE "product" ADD FOREIGN KEY ("id_sub_category") REFERENCES "sub_category" ("id");

ALTER TABLE "attribute_product" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id");

ALTER TABLE "attribute_product" ADD FOREIGN KEY ("id_attribute") REFERENCES "attribute" ("id");

ALTER TABLE "user" ADD FOREIGN KEY ("id_role") REFERENCES "role" ("id");

ALTER TABLE "order" ADD FOREIGN KEY ("id_user") REFERENCES "user" ("id");

ALTER TABLE "order_detail" ADD FOREIGN KEY ("id_order") REFERENCES "order" ("id");

ALTER TABLE "attribute_item" ADD FOREIGN KEY ("id_attribute") REFERENCES "attribute" ("id");

ALTER TABLE "attribute_item" ADD FOREIGN KEY ("id_item") REFERENCES "item" ("id");

ALTER TABLE "productoImage" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id");

ALTER TABLE "order_detail" ADD FOREIGN KEY ("id_procuct") REFERENCES "product" ("id");

ALTER TABLE "order_detail" ADD FOREIGN KEY ("id") REFERENCES "order" ("tracking_number");

ALTER TABLE "payment" ADD FOREIGN KEY ("id_payment_method") REFERENCES "payment_method" ("id");

ALTER TABLE "payment" ADD FOREIGN KEY ("id_order") REFERENCES "order" ("id");
