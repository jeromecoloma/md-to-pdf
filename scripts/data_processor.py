#!/usr/bin/env python3
"""
data_processor.py - Python helper for polyglot-example

This script demonstrates Python functionality that can be called from Bash scripts
using the Shell Starter polyglot utilities. It provides data processing, JSON handling,
and scientific computation capabilities.
"""

import argparse
import json
import sys
from datetime import datetime
from typing import Dict, List, Any


def process_data(data: List[Dict[str, Any]], operation: str) -> Dict[str, Any]:
    """Process data based on the specified operation."""
    result = {
        "timestamp": datetime.now().isoformat(),
        "operation": operation,
        "input_count": len(data),
        "results": {}
    }
    
    if operation == "analyze":
        # Statistical analysis
        if data:
            numeric_fields = []
            for item in data:
                for key, value in item.items():
                    if isinstance(value, (int, float)):
                        numeric_fields.append(value)
            
            if numeric_fields:
                result["results"] = {
                    "count": len(numeric_fields),
                    "sum": sum(numeric_fields),
                    "average": sum(numeric_fields) / len(numeric_fields),
                    "min": min(numeric_fields),
                    "max": max(numeric_fields)
                }
            else:
                result["results"] = {"message": "No numeric data found for analysis"}
        else:
            result["results"] = {"message": "No data provided for analysis"}
    
    elif operation == "transform":
        # Data transformation
        transformed = []
        for i, item in enumerate(data):
            new_item = {"id": i + 1, "original": item}
            if isinstance(item, dict):
                # Add computed fields
                new_item["field_count"] = len(item)
                new_item["has_numeric"] = any(isinstance(v, (int, float)) for v in item.values())
            transformed.append(new_item)
        result["results"] = {"transformed_data": transformed}
    
    elif operation == "validate":
        # Data validation
        validation_results = []
        for i, item in enumerate(data):
            validation = {
                "index": i,
                "valid": True,
                "issues": []
            }
            
            if not isinstance(item, dict):
                validation["valid"] = False
                validation["issues"].append("Item is not a dictionary")
            else:
                if not item:
                    validation["issues"].append("Empty dictionary")
                if any(key.strip() == "" for key in item.keys() if isinstance(key, str)):
                    validation["issues"].append("Contains empty string keys")
            
            validation_results.append(validation)
        
        valid_count = sum(1 for v in validation_results if v["valid"])
        result["results"] = {
            "validation_summary": {
                "total_items": len(validation_results),
                "valid_items": valid_count,
                "invalid_items": len(validation_results) - valid_count
            },
            "details": validation_results
        }
    
    elif operation == "format":
        # Format data for display
        formatted_items = []
        for item in data:
            if isinstance(item, dict):
                formatted = []
                for key, value in item.items():
                    formatted.append(f"{key}: {value}")
                formatted_items.append(" | ".join(formatted))
            else:
                formatted_items.append(str(item))
        result["results"] = {"formatted_output": formatted_items}
    
    else:
        result["results"] = {"error": f"Unknown operation: {operation}"}
    
    return result


def generate_sample_data(count: int, data_type: str) -> List[Dict[str, Any]]:
    """Generate sample data for testing."""
    sample_data = []
    
    if data_type == "users":
        for i in range(count):
            sample_data.append({
                "id": i + 1,
                "name": f"User{i + 1}",
                "email": f"user{i + 1}@example.com",
                "age": 20 + (i % 50),
                "active": i % 2 == 0
            })
    elif data_type == "products":
        for i in range(count):
            sample_data.append({
                "id": i + 1,
                "name": f"Product {i + 1}",
                "price": round(10.0 + (i * 5.5), 2),
                "category": ["Electronics", "Books", "Clothing", "Home"][i % 4],
                "in_stock": i % 3 != 0
            })
    elif data_type == "metrics":
        for i in range(count):
            sample_data.append({
                "timestamp": f"2024-01-{(i % 30) + 1:02d}",
                "value": round(100 + (i * 2.3), 1),
                "status": "ok" if i % 4 != 0 else "warning"
            })
    else:
        for i in range(count):
            sample_data.append({
                "index": i,
                "value": i * 2,
                "label": f"Item {i}"
            })
    
    return sample_data


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description="Python data processor for Shell Starter polyglot examples"
    )
    
    parser.add_argument(
        "operation",
        choices=["analyze", "transform", "validate", "format", "generate"],
        help="Operation to perform on the data"
    )
    
    parser.add_argument(
        "--input",
        type=str,
        help="Input JSON data (or use stdin)"
    )
    
    parser.add_argument(
        "--output",
        type=str,
        help="Output file path (default: stdout)"
    )
    
    parser.add_argument(
        "--pretty",
        action="store_true",
        help="Pretty-print JSON output"
    )
    
    # Options for generate operation
    parser.add_argument(
        "--count",
        type=int,
        default=5,
        help="Number of sample items to generate (for generate operation)"
    )
    
    parser.add_argument(
        "--type",
        choices=["users", "products", "metrics", "generic"],
        default="generic",
        help="Type of sample data to generate"
    )
    
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable verbose output"
    )
    
    args = parser.parse_args()
    
    try:
        if args.verbose:
            print(f"Python processor starting: {args.operation}", file=sys.stderr)
        
        if args.operation == "generate":
            # Generate sample data
            data = generate_sample_data(args.count, args.type)
            result = {
                "timestamp": datetime.now().isoformat(),
                "operation": "generate",
                "generated_count": len(data),
                "data_type": args.type,
                "data": data
            }
        else:
            # Process input data
            if args.input:
                # Input from argument
                try:
                    data = json.loads(args.input)
                except json.JSONDecodeError as e:
                    print(f"Error parsing input JSON: {e}", file=sys.stderr)
                    sys.exit(1)
            else:
                # Input from stdin
                try:
                    input_text = sys.stdin.read().strip()
                    if not input_text:
                        data = []
                    else:
                        data = json.loads(input_text)
                except json.JSONDecodeError as e:
                    print(f"Error parsing stdin JSON: {e}", file=sys.stderr)
                    sys.exit(1)
            
            # Ensure data is a list
            if not isinstance(data, list):
                data = [data]
            
            result = process_data(data, args.operation)
        
        # Output result
        if args.pretty:
            output = json.dumps(result, indent=2, ensure_ascii=False)
        else:
            output = json.dumps(result, ensure_ascii=False)
        
        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(output)
            if args.verbose:
                print(f"Output written to: {args.output}", file=sys.stderr)
        else:
            print(output)
        
        if args.verbose:
            print("Python processor completed successfully", file=sys.stderr)
    
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()