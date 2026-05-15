## Setup
TODO:

## Commit messages

- Example:
  - `Fix typo`
  - `Move filetype config to after/ftplugin`

## Branch and PR Workflow

For issue-based work, create one branch per issue.

### Branch naming:

- Preferred: `<type>-<issue-number>`
  - Type Example
    - `fix` for bug fixes
    - `feat` for new behavior
    - `docs` for documentation-only changes
    - `refactor` for behavior-preserving restructuring
- Example
  - `fix-123`
  - `docs-111`

### Pull requests:

- Open one PR per issue.
- PR title should include the issue number.
- PR body should include `Closes #<issue-number>` when the PR fully resolves the issue.
- Keep unrelated changes out of the PR.
- Run the smallest relevant verification before opening the PR.
