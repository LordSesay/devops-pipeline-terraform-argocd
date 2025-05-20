#!/usr/bin/env python3
import requests
import sys
import time

def test_app():
    """Test if the application is running and responding correctly"""
    base_url = "http://localhost:8080"
    endpoints = {
        "/": {"expected_status": 200, "expected_content": "Welcome"},
        "/health": {"expected_status": 200, "expected_content": "healthy"},
        "/info": {"expected_status": 200, "expected_content": "DevOps Demo"}
    }
    
    all_passed = True
    
    print("🧪 Testing application endpoints...")
    
    for endpoint, expectations in endpoints.items():
        url = f"{base_url}{endpoint}"
        try:
            print(f"  Testing {url}...")
            response = requests.get(url, timeout=5)
            
            # Check status code
            status_ok = response.status_code == expectations["expected_status"]
            if not status_ok:
                print(f"    ❌ Expected status {expectations['expected_status']}, got {response.status_code}")
                all_passed = False
            else:
                print(f"    ✅ Status code: {response.status_code}")
            
            # Check content
            content_ok = expectations["expected_content"] in response.text
            if not content_ok:
                print(f"    ❌ Expected content containing '{expectations['expected_content']}' not found")
                all_passed = False
            else:
                print(f"    ✅ Content check passed")
                
        except requests.exceptions.RequestException as e:
            print(f"    ❌ Error connecting to {url}: {e}")
            all_passed = False
    
    if all_passed:
        print("\n✅ All tests passed! Application is working correctly.")
        return 0
    else:
        print("\n❌ Some tests failed. Please check the application.")
        return 1

if __name__ == "__main__":
    print("🚀 Starting application tests...")
    print("Make sure the application is running and port-forwarded to localhost:8080")
    
    # Give a moment for user to read instructions
    time.sleep(2)
    
    sys.exit(test_app())