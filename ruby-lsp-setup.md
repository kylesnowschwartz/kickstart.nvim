# Ruby LSP Setup for Rails Development

This guide explains how to set up and use the Ruby LSP configuration for Rails projects.

## Prerequisites

### Option 1: Global Installation (Recommended for large, shared projects)

For large, established projects like Marketplace, use a globally installed Ruby LSP:

```bash
gem install ruby-lsp standardrb
```

This approach avoids modifying the project's Gemfile, which is crucial for large, established projects with many contributors.

### Option 2: Project Gemfile (For smaller or personal projects)

For smaller projects where you control the Gemfile:

```ruby
group :development do
  gem "ruby-lsp", require: false
  gem "standard", require: false  # For standardrb formatting
end
```

Then run:

```bash
bundle install
```

## Project Configuration

### 1. Create a `.neoconf.ruby.json` File

Copy the example configuration to your project:

```bash
cp ~/.config/nvim/example.neoconf.ruby.json ~/Code/marketplace/.neoconf.ruby.json
```

Adjust as needed for your specific project requirements.

### 2. Testing the Setup

1. Open a Ruby file in your project:
   ```
   nvim app/models/your_model.rb
   ```

2. Check the LSP connection:
   ```
   :LspInfo
   ```
   Verify that ruby_lsp is attached to the buffer.

3. Test method definitions:
   - Place cursor on a method call
   - Press `gd` to go to definition
   - If it's in a bundled gem, it should find and jump to the definition

### 3. Using Rails Navigation

The vim-rails plugin provides enhanced Rails-specific navigation:

- `:Emodel user` - Jump to user model
- `:Econtroller users` - Jump to users controller
- `:Eview users/index` - Jump to users index view
- `:Emigration` - List migrations
- `:Eschema` - Open schema.rb

### 4. Running Tests

Use these commands to run tests:

- `<leader>rt` - Run the current test file
- `<leader>rs` - Run the test at the current cursor position
- `<leader>rl` - Run the last test
- `<leader>ra` - Run all tests

## Troubleshooting

### Method Definitions Not Found

If bundled gem methods aren't being found:

1. Check that bundle show is working:
   ```bash
   cd ~/Code/marketplace
   bundle show --paths
   ```

2. If specific gems aren't detected, add them manually in `.neoconf.ruby.json`:
   ```json
   "bundleGemPaths": [
     "/path/to/specific/gem"
   ]
   ```

3. Make sure you've added ruby-lsp to your Gemfile

### Rails-Specific Navigation

- If Rails navigation isn't working, ensure your project structure follows Rails conventions.
- Rails detection should be automatic for standard projects.

## Diagnostics Not Showing

- Check if RuboCop is installed: `bundle list | grep rubocop`
- Ensure your `.rubocop.yml` is properly configured
- Try running manually: `bundle exec rubocop`

## Updates and Maintenance

As Ruby LSP improves over time, you may want to:

1. Update your gems: `bundle update ruby-lsp`
2. Check for new features in the Ruby LSP repository
3. Update your configuration as new settings become available

## References

- [Ruby LSP Documentation](https://github.com/Shopify/ruby-lsp)
- [Ruby Standard Documentation](https://github.com/standardrb/standard)
- [Vim-Rails Documentation](https://github.com/tpope/vim-rails)
- [Vim-Test Documentation](https://github.com/vim-test/vim-test)