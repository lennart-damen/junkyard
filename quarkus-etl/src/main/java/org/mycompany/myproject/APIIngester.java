package org.mycompany.myproject;

import com.fasterxml.jackson.databind.json.JsonMapper;
import io.quarkus.logging.Log;
import io.quarkus.scheduler.Scheduled;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.openapi.quarkus.source_api_json.api.ActivitiesApi;
import org.openapi.quarkus.source_api_json.model.Activity;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@ApplicationScoped
public class APIIngester {
    @RestClient
    ActivitiesApi activitiesApi;

    @ConfigProperty(name = "application.data-directory")
    String dataDirectory;

    @Scheduled(every = "PT1M")
    public void ingest() throws IOException {
        Log.info("Starting ingestion...");
        List<Activity> activities = activitiesApi.apiV1ActivitiesGet();
        String filePath = getFilePath(dataDirectory);
        JsonMapper objectMapper = JsonMapper.builder().findAndAddModules().build();
        objectMapper.writeValue(new File(filePath), activities);
        Log.info("Ingestion successful!");
    }

    private String getFilePath(String folder) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        LocalDateTime currentDateTime = LocalDateTime.now();
        String formattedDateTime = currentDateTime.format(formatter);
        return folder + "/" + formattedDateTime + ".json";
    }
}
