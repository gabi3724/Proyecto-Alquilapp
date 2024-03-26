# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_03_030440) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "global_id"
    t.string "dni"
    t.datetime "fecha_nacimiento"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alquilers", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "auto_id", null: false
    t.decimal "costo"
    t.integer "horas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "porcentaje_tanque_inicial"
    t.boolean "fue_encendido"
    t.index ["auto_id"], name: "index_alquilers_on_auto_id"
    t.index ["usuario_id"], name: "index_alquilers_on_usuario_id"
  end

  create_table "autos", force: :cascade do |t|
    t.string "patente"
    t.string "marca"
    t.string "modelo"
    t.string "color"
    t.string "tipo_de_caja"
    t.string "tipo_de_motor"
    t.string "autonomia"
    t.text "como_cargar"
    t.integer "porcentaje_tanque"
    t.boolean "encendido", default: false
    t.boolean "alquilado", default: false
    t.point "ubicacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancelados", force: :cascade do |t|
    t.string "motivo"
    t.string "patente"
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_cancelados_on_usuario_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "numero"
    t.string "codigo"
    t.string "titular"
    t.datetime "fecha_vencimiento"
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_cards_on_usuario_id"
  end

  create_table "costos", force: :cascade do |t|
    t.integer "combustible"
    t.integer "alquiler"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docs", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estado"
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "vencimiento"
    t.index ["usuario_id"], name: "index_docs_on_usuario_id"
  end

  create_table "incidences", force: :cascade do |t|
    t.text "descripcion"
    t.bigint "auto_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auto_id"], name: "index_incidences_on_auto_id"
  end

  create_table "lics", force: :cascade do |t|
    t.string "descripcion"
    t.integer "estado"
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "vencimiento"
    t.index ["usuario_id"], name: "index_lics_on_usuario_id"
  end

  create_table "problemas", force: :cascade do |t|
    t.text "descripcion"
    t.integer "auto_id"
    t.integer "sup_id"
    t.string "sup_dni"
    t.boolean "resuelto", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "resolucion"
  end

  create_table "sups", force: :cascade do |t|
    t.string "global_id"
    t.string "dni"
    t.datetime "fecha_nacimiento"
    t.string "password"
    t.integer "auto_id"
    t.string "nombre_completo"
    t.point "ubicacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "global_id"
    t.string "dni"
    t.datetime "fecha_nacimiento"
    t.string "password"
    t.integer "auto_id"
    t.integer "creditos"
    t.boolean "validado", default: false
    t.string "nombre_completo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "en_revision"
    t.datetime "fecha_ultimo_alquiler"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alquilers", "autos"
  add_foreign_key "alquilers", "usuarios"
  add_foreign_key "cards", "usuarios"
  add_foreign_key "docs", "usuarios"
  add_foreign_key "lics", "usuarios"
end
