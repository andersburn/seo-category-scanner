#!/usr/bin/env bash
# Run the script: 
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# brew install pup
# chmod +x seo_audit.sh
# ./seo_audit.sh


set -euo pipefail

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Safari"
#DELAY in secs
DELAY_BETWEEN_REQUESTS=1

##Path Class to list elements of products -this case: div.products
SELECTOR_PRODUCT_CLASS="product"
#Path Class to category short text: div.category-short
SELECTOR_CATEGORY_DETAILS_CLASS="category-short"
#Path Class to category long text: div.category-long
SELECTOR_CATEGORY_SECONDARY_CLASS="category-long"

URLS=(
"https://URL.com/1-category/"
"https://URL.com/2-category/"
"https://URL.com/3-category/"
"https://URL.com/4-category/"
"https://URL.com/5-category/"
)

text_len() {
  tr '\n' ' ' | sed 's/[[:space:]]\+/ /g; s/^ *//; s/ *$//' | wc -m | tr -d ' '
}

count_h1() {
  perl -0777 -ne '$c=0; $c++ while /<h1\b/ig; print $c' "$1"
}

count_div_with_class_token() {
  local token="$1"
  local file="$2"
  perl -0777 -e '
	my ($t, $file) = @ARGV;
	open my $fh, "<", $file or die $!;
	local $/;
	my $html = <$fh>;
	my $c = 0;
	while ($html =~ /<div\b[^>]*\bclass\s*=\s*(["\x27])[^"\x27]*\b\Q$t\E\b[^"\x27]*\1[^>]*>/ig) { $c++ }
	print $c;
  ' "$token" "$file"
}

extract_div_text_by_class() {
  local token="$1"
  local file="$2"
  perl -0777 -e '
	my ($t, $file) = @ARGV;
	open my $fh, "<", $file or die $!;
	local $/;
	my $html = <$fh>;
	if ($html =~ /<div\b[^>]*\bclass\s*=\s*(["\x27])[^"\x27]*\b\Q$t\E\b[^"\x27]*\1[^>]*>(.*?)<\/div>/is) {
	  print $2;
	}
  ' "$token" "$file" | text_len
}

out="seo_audit_$(date +%Y%m%d_%H%M%S).csv"
printf "url,http_status,h1_count,product_div_count,title_len,meta_desc_len,category_details_text_len,category_info_secondary_text_len\n" > "$out"

for url in "${URLS[@]}"; do
  tmp="$(mktemp)"
  hdr="$(mktemp)"

  curl -sS -L --compressed -A "$USER_AGENT" -D "$hdr" -o "$tmp" "$url" || true
  http_status="$(awk 'BEGIN{c=0} /^HTTP\//{c++; s=$2} END{print s+0}' "$hdr")"

  h1_count="$(count_h1 "$tmp")"
  product_div_count="$(count_div_with_class_token "$SELECTOR_PRODUCT_CLASS" "$tmp")"

  title_len="$(perl -0777 -ne 'print $1 if /<title[^>]*>(.*?)<\/title>/is' "$tmp" | text_len || true)"
  meta_desc_len="$(perl -0777 -ne 'print $3 if /<meta\b[^>]*name\s*=\s*(["'\''])description\1[^>]*content\s*=\s*(["'\''])(.*?)\2/is' "$tmp" | text_len || true)"

  cat_details_len="$(extract_div_text_by_class "$SELECTOR_CATEGORY_DETAILS_CLASS" "$tmp" || echo 0)"
  cat_secondary_len="$(extract_div_text_by_class "$SELECTOR_CATEGORY_SECONDARY_CLASS" "$tmp" || echo 0)"

  printf "\"%s\",%s,%s,%s,%s,%s,%s,%s\n" \
	"$url" \
	"${http_status:-0}" \
	"${h1_count:-0}" \
	"${product_div_count:-0}" \
	"${title_len:-0}" \
	"${meta_desc_len:-0}" \
	"${cat_details_len:-0}" \
	"${cat_secondary_len:-0}" >> "$out"

  rm -f "$tmp" "$hdr"
  sleep "$DELAY_BETWEEN_REQUESTS"
done

echo "Saved: $out"