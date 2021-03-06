package org.openmrs.module.conceptpropose.pagemodel;

import org.apache.commons.lang.StringUtils;
import org.openmrs.module.conceptpropose.functionaltest.steps.SeleniumDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;

public class QueryBrowserPage {

	private final String queryBrowserPageUrl;
	private WebDriver driver;
	private String openmrsUrl;

	public QueryBrowserPage() throws IOException {
		this.driver = SeleniumDriver.getDriver(); // request current driver every time new page constructed

		if (StringUtils.isNotBlank(System.getenv("openmrs_username"))) {
//			username = System.getenv("openmrs_username");
//			password = System.getenv("openmrs_password");

			if (StringUtils.isNotBlank(System.getenv("openmrs_url"))) {
				openmrsUrl = System.getenv("openmrs_url");
			}

			queryBrowserPageUrl = String.format("http://%s/%s/module/querybrowser/manage.form", System.getenv("openmrs_server"), openmrsUrl);
		} else {
			final Properties p = new Properties();
			final InputStream is = getClass().getResourceAsStream("/config.properties");

			p.load(new InputStreamReader(is));
//			username = p.getProperty("username");
//			password = p.getProperty("password");
			queryBrowserPageUrl = p.getProperty("openmrsUrl") + "/module/querybrowser/manage.form";
		}
	}

	public void removeAllProposals() {
		driver.get(queryBrowserPageUrl);

		final WebElement queryEl = driver.findElement(By.cssSelector("textarea[ng-model=\"query\"]"));
		queryEl.sendKeys("delete from conceptpropose_proposed_concept_package");
		driver.findElement(By.xpath("//button[contains(text(),'Submit Query')]")).click();
	}

}
