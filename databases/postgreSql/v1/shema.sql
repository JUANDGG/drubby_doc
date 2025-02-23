CREATE TABLE "user" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(50) NOT NULL CHECK (name ~ '^[A-Za-zÁÉÍÓÚÑáéíóúñ ]+$'),
  "email" VARCHAR(100) NOT NULL UNIQUE CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  "password_hash" VARCHAR(150) NOT NULL,
  "state" BOOLEAN NOT NULL DEFAULT TRUE ,
  "id_role" INTEGER NOT NULL ,
  "created_at" TIMESTAMP NOT NULL DEFAULT NOW()

);

CREATE TABLE "verification_code" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_user" INTEGER NOT NULL ,
  "code" VARCHAR(6) NOT NULL CHECK (code ~ '^[0-9]{6}$') UNIQUE,
  "expires_at" TIMESTAMP NOT NULL CHECK (expires_at > NOW()),
  "is_used" BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE "role" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "permission" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "role_permission" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_role" INTEGER NOT NULL ,
  "id_permission" INTEGER NOT NULL ,
  "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE(id_role, id_permission)
);

CREATE TABLE "category" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "sub_category" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE ,
  "id_category" INTEGER NOT NULL
);

CREATE TABLE "item" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "attribute" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "attribute_item" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_attribute" INTEGER NOT NULL,
  "id_item" INTEGER NOT NULL
);

CREATE TABLE "product" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z0-9 ]+$'),
  "description" TEXT NOT NULL,
  "unit_price" NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
  "stock" INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  "state" BOOLEAN NOT NULL DEFAULT TRUE ,
  "creation_date" TIMESTAMP NOT NULL DEFAULT NOW(),
  "id_sub_category" INTEGER NOT NULL
);

CREATE TABLE "product_image" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "url" TEXT NOT NULL,
  "state" BOOLEAN NOT NULL DEFAULT TRUE ,
  "id_product" INTEGER NOT NULL
);

CREATE TABLE "attribute_product" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_product" INTEGER NOT NULL,
  "id_attribute" INTEGER NOT NULL
);

CREATE TABLE "order" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_user" INTEGER NOT NULL,
  "total" NUMERIC(10,2) NOT NULL CHECK (total > 0),
  "state" VARCHAR(30) NOT NULL CHECK (state IN ('pending', 'processing', 'paid', 'canceled')),
  "payment_status" VARCHAR(30) NOT NULL CHECK (payment_status IN ('pending', 'approved', 'rejected')),
  "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
  "country" VARCHAR(50) NOT NULL CHECK (country ~ '^[A-Za-z ]+$'),
  "city" VARCHAR(50) NOT NULL CHECK (city ~ '^[A-Za-z ]+$'),
  "region" VARCHAR(50) CHECK (region ~ '^[A-Za-z ]*$') DEFAULT NULL,
  "address" TEXT NOT NULL,
  "postal_code" VARCHAR(20) NOT NULL CHECK (postal_code ~ '^[0-9]+$'),
  "tracking_number" VARCHAR(50) UNIQUE
);

CREATE TABLE "order_detail" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_order" INTEGER NOT NULL,
  "id_product" INTEGER NOT NULL,
  "quantity" INTEGER NOT NULL CHECK (quantity > 0),
  "price_product" NUMERIC(10,2) NOT NULL CHECK (price_product > 0),
  "discount" NUMERIC(5,2) CHECK (discount >= 0),
  "subtotal" NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0)
);

CREATE TABLE "payment_method" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(50) NOT NULL CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN
);

CREATE TABLE "payment" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_order" INTEGER NOT NULL,
  "id_payment_method" INTEGER NOT NULL,
  "amount" NUMERIC(10,2) CHECK (amount > 0),
  "status" VARCHAR(30) NOT NULL CHECK (status IN ('pending', 'processed', 'failed', 'refunded')),
  "created_at" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "transaction_type" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" VARCHAR(30) NOT NULL UNIQUE CHECK (name ~ '^[A-Za-z ]+$'),
  "state" BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE "transaction" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "id_payment" INTEGER NOT NULL,
  "id_transaction_type" INTEGER NOT NULL,
  "transaction_number" VARCHAR(100) NOT NULL UNIQUE,
  "amount" NUMERIC(10,2) NOT NULL CHECK (amount > 0),
  "status" VARCHAR(30) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  "currency" VARCHAR(3) NOT NULL CHECK (currency ~ '^[A-Z]{3}$'),
  "created_at" TIMESTAMP DEFAULT NOW() NOT NULL
);


ALTER TABLE "role_permission"
ADD FOREIGN KEY ("id_role") REFERENCES "role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "role_permission"
ADD FOREIGN KEY ("id_permission") REFERENCES "permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sub_category"
ADD FOREIGN KEY ("id_category") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product"
ADD FOREIGN KEY ("id_sub_category") REFERENCES "sub_category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "attribute_product"
ADD FOREIGN KEY ("id_product") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "attribute_product"
ADD FOREIGN KEY ("id_attribute") REFERENCES "attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user"
ADD FOREIGN KEY ("id_role") REFERENCES "role"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "order"
ADD FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "order_detail"
ADD FOREIGN KEY ("id_order") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "attribute_item"
ADD FOREIGN KEY ("id_attribute") REFERENCES "attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "attribute_item"
ADD FOREIGN KEY ("id_item") REFERENCES "item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_image"
ADD FOREIGN KEY ("id_product") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order_detail"
ADD FOREIGN KEY ("id_product") REFERENCES "product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "payment"
ADD FOREIGN KEY ("id_payment_method") REFERENCES "payment_method"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "payment"
ADD FOREIGN KEY ("id_order") REFERENCES "order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "transaction"
ADD FOREIGN KEY ("id_payment") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "transaction"
ADD FOREIGN KEY ("id_transaction_type") REFERENCES "transaction_type"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "verification_code"
ADD FOREIGN KEY ("id_user") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;


CREATE INDEX idx_user_role ON "user"("id_role");
CREATE INDEX idx_order_user ON "order"("id_user");
CREATE INDEX idx_product_subcategory ON "product"("id_sub_category");
