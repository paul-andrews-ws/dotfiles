---
name: Strong Migrations doesn't introspect change_table
description: Use add_column (not change_table) for additive column migrations in the wealthsimple monolith — Strong Migrations errors out on change_table blocks
type: feedback
originSessionId: 4f84d690-df7d-4949-9198-8a323dd8a58e
---
In the wealthsimple monolith, the Strong Migrations gem aborts any migration that uses `change_table` with:

> Strong Migrations does not support inspecting what happens inside a change_table block, so cannot help you here. Please make really sure that what you're doing is safe before proceeding, then wrap it in a safety_assured { ... } block.

**Why:** Knowing this avoids a roundtrip: write the migration → fail → rewrite as `add_column` lines.

**How to apply:** For additive column migrations, use per-column `add_column` calls instead of grouping them in a `change_table` block:

```ruby
# Good — Strong Migrations can verify safety
class AddSomethingToCorporations < ActiveRecord::Migration[8.1]
  def change
    add_column :corporations, :foo, :string
    add_column :corporations, :bar, :datetime
  end
end

# Bad — Strong Migrations refuses
class AddSomethingToCorporations < ActiveRecord::Migration[8.1]
  def change
    change_table :corporations do |t|
      t.string :foo
      t.datetime :bar
    end
  end
end
```

`safety_assured { ... }` wrapping is an escape hatch but generally not needed for additive nullable columns — `add_column` is the idiomatic path.
