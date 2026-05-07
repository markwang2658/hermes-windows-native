---
name: data-science-tools
description: Comprehensive set of tools for data science workflows including Jupyter notebooks, ML evaluation, and iterative exploration.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [data-science, jupyter, notebook, ml-evaluation, iterative-exploration]
    category: data-science
---

# Data Science Tools

## Overview
This skill provides a comprehensive set of tools for data science workflows including Jupyter notebooks, ML evaluation frameworks, and iterative exploration capabilities.

## Core Components

### 1. Jupyter Live Kernel (jupyter-live-kernel)
Provides stateful Python REPL via live Jupyter kernel with persistent variables across executions.
- **Use Cases**: Iterative code exploration, data analysis, machine learning prototyping
- **Key Features**:
  - State persistence between executions
  - Interactive variable inspection
  - Cell editing capabilities
  - Multi-line execution support

### 2. ML Evaluation Frameworks (mlops/evaluation)
Support for benchmarking and evaluating machine learning models.
- **Use Cases**: Model performance comparison, evaluation metric calculation
- **Key Features**:
  - Benchmarking across multiple datasets
  - Standard evaluation metrics
  - Comparative analysis tools
  - Performance visualization

## Workflow Patterns

### Iterative Data Science Workflow
```python
# Example workflow using data-science-tools
from data_science_tools import jupyter_kernel, ml_evaluation

# Initialize Jupyter kernel session
kernel = jupyter_kernel.start_session()

# Load and explore dataset
df = kernel.execute("import pandas as pd; df = pd.read_csv('data.csv')")
print(kernel.variables['df'].preview())

# Apply ML model evaluation
results = ml_evaluation.benchmark_model(
    models=['logistic_regression', 'random_forest'],
    metrics=['accuracy', 'precision']
)

kernel.stop_session()
```

## Best Practices

### Jupyter Kernel Usage Guidelines
1. **State Management**: Use the same notebook session for continuous exploration to maintain variable state
2. **Resource Management**: Properly stop sessions when done to release resources
3. **Error Handling**: Expect JSON-formatted error responses with `ename` and `evalue` fields

### ML Evaluation Best Practices
- Always compare models on multiple evaluation metrics
- Use cross-validation for robust performance estimates
- Document evaluation results systematically

## Troubleshooting Common Issues

### Jupyter Kernel Timeout Errors
- **Cause**: First execution after server start may timeout due to kernel initialization
- **Solution**:
  ```bash
  # Retry with increased timeout
  uv run \"$SCRIPT\" execute --path scratch.ipynb --code ... --timeout 120
  ```

### Variable Persistence Issues
- **Cause**: Kernel restarts or session termination can clear state
- **Solution**: Use `restart-run-all` command to verify notebook execution

## Support Files
- [Data Science Tools Reference Guide](references/data_science_tools_reference.md) - Detailed configuration and usage instructions

## Future Enhancements
- Integration with popular ML frameworks (TensorFlow, PyTorch)
- Automated evaluation report generation
- Interactive visualization tools