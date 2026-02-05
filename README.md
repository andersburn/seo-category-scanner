# SEO Category Scanner (Bash)

A lightweight command-line tool for bulk on-page SEO checks of category pages.  
This script fetches each URL, scans the HTML, and extracts important SEO and structural signals such as headings, metadata, product counts, and category content length.

It is built for fast technical and content audits of **large e-commerce category structures**.

---

## 📌 Project Overview

This project helps you quickly evaluate the SEO health of category pages at scale.  
Instead of manually checking each page, the script analyzes multiple URLs automatically and exports the results into a structured CSV report.

---

## 🚀 Features

The script checks each provided URL for:

- Number of **H1 tags**
- Number of **product blocks**
- Length of the **Title tag**
- Length of the **Meta description**
- Text length inside the **main category description**
- Text length inside the **secondary SEO content block**
- **HTTP status code**

All results are saved into a timestamped CSV file for easy analysis.

---

## 🛠 Requirements

You need the following tools installed on your system (macOS compatible):

| Tool | Purpose |
|------|---------|
| **bash** | Script execution |
| **curl** | Download page HTML |
| **perl** | Pattern matching & parsing |
| **sed / awk / wc** | Text processing |

### Check if they are installed

```bash
bash --version
curl --version
perl -v
```
These are preinstalled on most Mac systems.

---

## 📥 Installation

Clone the repository /download the script
```
git clone https://github.com/andersburn/seo-category-scanner.git
cd seo-category-scanner
```
Make the script executable
```
chmod +x seo_audit.sh
```
Run the script
```
./seo_audit.sh
```
A CSV report will be created in the same folder.

---

## ⚙️ Configuration

At the top of the script, you can adjust constants to match other websites.

⏱ Crawl Delay

DELAY_BETWEEN_REQUESTS=2

Pause (seconds) between each request to avoid server overload.

---

## 🧩 Change HTML Elements to Scan

These values define which parts of the page are measured.

SELECTOR_PRODUCT_CLASS="product"
SELECTOR_CATEGORY_DETAILS_CLASS="category-details"
SELECTOR_CATEGORY_SECONDARY_CLASS="category-info-secondary"

Setting	Purpose
SELECTOR_PRODUCT_CLASS	Counts product container <div> elements
SELECTOR_CATEGORY_DETAILS_CLASS	Main category description text
SELECTOR_CATEGORY_SECONDARY_CLASS	Secondary SEO content block

Update these if your theme uses different class names.

---

## 🌍 Add URLs to Scan

URLS=(
"https://example.com/category-a/"
"https://example.com/category-b/"
)

You can add as many URLs as needed.

---

## 📊 Output

The script creates a CSV file like:

seo_audit_20260205_142301.csv

Output Columns

Column	Description
url	Scanned page
http_status	HTTP response code
h1_count	Number of H1 tags
product_div_count	Number of product blocks
title_len	Title tag character length
meta_desc_len	Meta description character length
category_details_text_len	Main category text length
category_info_secondary_text_len	Secondary SEO text length

Open the file in Excel, Google Sheets, or any BI tool.

---

## 🎯 Use Cases

This tool helps you:
	•	Detect missing or duplicate H1 tags
	•	Identify thin category pages
	•	Find short or missing meta descriptions
	•	Verify product grid rendering
	•	Monitor SEO quality after theme updates
	•	Perform large-scale technical SEO audits

---

## ⚠️ Limitations
	•	Uses pattern matching, not a full HTML parser
	•	Cannot read JavaScript-rendered content
	•	Complex or unusual markup may require selector adjustments

---

## 🔧 When You Should Modify the Script

You may need to change selectors if:
	•	Your website theme changes
	•	Class names are updated
	•	Product containers use a different structure
	•	Category text sections move to new containers

All configurable values are located at the top of the script.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## 📄 License

Free to use and modify.

---

## 📬 Contact

If you have questions or improvements, open an issue in this repository.

