using AdventureWorks.Models;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdventureWorks.Context
{
    //implement iadventureworksproductcontext interface with a single read-only "Container" var
    public class AdventureWorksCosmosContext : IAdventureWorksProductContext
    {
        private readonly Container _container;
        //constructor creates a new instance of CosmosClient class, and then obtain both a database and container instance from the client
        public AdventureWorksCosmosContext(string connectionString, string database = "Retail", string container = "Online")
        {
            _container = new CosmosClient(connectionString)
                .GetDatabase(database)
                .GetContainer(container);
        }
        //FindModelAsync method creates a linq query, transforms it into an interator, iterates and returns the single item in the result set
        public async Task<Model> FindModelAsync(Guid id)
        {
            var iterator = _container.GetItemLinqQueryable<Model>()
                .Where(m => m.id == id)
                .ToFeedIterator<Model>();

            List<Model> matches = new List<Model>();
            while (iterator.HasMoreResults)
            {
                var next = await iterator.ReadNextAsync();
                matches.AddRange(next);
            }

            return matches.SingleOrDefault();
        }

        //GetModelsAsync method runs a sql query
        public async Task<List<Model>> GetModelsAsync()
        {
            string query = $@"SELECT * FROM items";

            var iterator = _container.GetItemQueryIterator<Model>(query);

            List<Model> matches = new List<Model>();
            while (iterator.HasMoreResults)
            {
                var next = await iterator.ReadNextAsync();
                matches.AddRange(next);
            }

            return matches;
        }
        public async Task<Product> FindProductAsync(Guid id)
        {
            string query = $@"SELECT VALUE products
                        FROM models
                        JOIN products in models.Products
                        WHERE products.id = '{id}'";

            var iterator = _container.GetItemQueryIterator<Product>(query);

            List<Product> matches = new List<Product>();
            while (iterator.HasMoreResults)
            {
                var next = await iterator.ReadNextAsync();
                matches.AddRange(next);
            }

            return matches.SingleOrDefault();
        }
    }
}